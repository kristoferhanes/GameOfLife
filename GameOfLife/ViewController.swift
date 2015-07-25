//
//  ViewController.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

private struct Constants {
  static let defaultCellSize: CGFloat = 10
  static let FrameLength = 1.0 / 30.0
  static let ButtonStopTitle = "Stop"
  static let ButtonStartTitle = "Start"
}

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var startStopButton: UIBarButtonItem!

  var cellBoard = CellBoard()
  var renderer = CellBoardRenderer(
    bounds: CGRect(),
    cellSize: Constants.defaultCellSize)

  var timer: NSTimer?

  var lastFrameTimeStamp = NSDate.timestamp

  var isRunning: Bool {
    return startStopButton.title == Constants.ButtonStopTitle
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    renderer = CellBoardRenderer(
      bounds: CGRect(origin: CGPoint(x: 0, y: 0), size: imageView.bounds.size),
      cellSize: renderer.cellSize)
  }

  @IBAction func clearCells(_: UIBarButtonItem) {
    turnOffTimer()
    startStopButton.title = Constants.ButtonStartTitle
    cellBoard = CellBoard()
    imageView.image = renderer.render(cellBoard.livingCells)
  }

  @IBAction func startStop(startStopButton: UIBarButtonItem) {
    startStopButton.title = startStopButton.toggleTitle
    if startStopButton.title == Constants.ButtonStopTitle { turnOnTimer() }
    else { turnOffTimer() }
  }

  @IBAction func tapGestureHandler(gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .Ended:
      let touchPoint = gesture.locationInView(gesture.view) - renderer.bounds.origin
      let cell = Cell(
        x: Int(touchPoint.x / renderer.cellSize),
        y: Int(touchPoint.y / renderer.cellSize))
      cellBoard = cellBoard.toggleCell(cell)
      imageView.image = renderer.render(cellBoard.livingCells)
    default: break
    }
  }

  @IBAction func panGestureHandler(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .Changed:
      let touchPoint = gesture.locationInView(gesture.view) - renderer.bounds.origin
      let cell = Cell(
        x: Int(touchPoint.x / renderer.cellSize),
        y: Int(touchPoint.y / renderer.cellSize))
      cellBoard = cellBoard.addCell(cell)
      let timeSinceLastFrame = NSDate.timestamp - lastFrameTimeStamp
      if timeSinceLastFrame > Constants.FrameLength {
        imageView.image = renderer.render(cellBoard.livingCells)
        lastFrameTimeStamp = NSDate.timeIntervalSinceReferenceDate()
      }
    default: break
    }
  }

  @IBAction func pinchGestureHandler(gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .Changed:
      let location = gesture.locationInView(gesture.view)
      let scale = gesture.scale
      let newCellSize = renderer.cellSize * scale
      let x = (renderer.bounds.origin.x - location.x) * scale + location.x
      let y = (renderer.bounds.origin.y - location.y) * scale + location.y
      let newBounds = CGRect(
        origin: CGPoint(x: x, y: y),
        size: imageView.bounds.size)
      renderer = CellBoardRenderer(bounds: newBounds, cellSize: newCellSize)
      let timeSinceLastFrame = NSDate.timestamp - lastFrameTimeStamp
      if timeSinceLastFrame > Constants.FrameLength {
        imageView.image = renderer.render(cellBoard.livingCells)
        lastFrameTimeStamp = NSDate.timeIntervalSinceReferenceDate()
      }
      gesture.scale = 1
    case .Ended:
      gesture.scale = 1
    default: break
    }
  }


  func drawNextFrame(_: NSTimer) {
    turnOffTimer()
    Future { completion in
      completion(self.cellBoard.next())
      }.start { newCellBoard in
        self.cellBoard = newCellBoard
        self.imageView.image = self.renderer.render(self.cellBoard.livingCells)
        if self.isRunning {
          self.turnOnTimer()
        }
    }
  }

  private func turnOnTimer() {
    timer?.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(Constants.FrameLength,
      target: self,
      selector: Selector("drawNextFrame:"),
      userInfo: nil,
      repeats: true)
  }

  private func turnOffTimer() {
    timer?.invalidate()
    timer = nil
  }
}

extension NSDate {
  private static var timestamp: NSTimeInterval {
    return NSDate.timeIntervalSinceReferenceDate()
  }
}

extension UIBarButtonItem {
  private var toggleTitle: String {
    switch title ?? "" {
    case Constants.ButtonStartTitle: return Constants.ButtonStopTitle
    case Constants.ButtonStopTitle: return Constants.ButtonStartTitle
    default: fatalError("Invalid button title")
    }
  }
}

private func - (lhs: CGPoint, rhs:CGPoint) -> CGPoint {
  let x = lhs.x - rhs.x
  let y = lhs.y - rhs.y
  return CGPoint(x: x, y: y)
}
