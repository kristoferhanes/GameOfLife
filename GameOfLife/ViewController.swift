//
//  ViewController.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

private struct Constants {
  static let defaultCellSize: CGFloat = 5
  static let FrameLength = 1.0 / 30.0
  static let GestureFrameLength = 1.0 / 30.0
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

  var animationIsRunning: Bool {
    return startStopButton.title == Constants.ButtonStopTitle
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    renderer = CellBoardRenderer(
      bounds: imageView.bounds,
      cellSize: renderer.cellSize)
  }

  @IBAction func clearCells(_: UIBarButtonItem) {
    turnOffAnimation()
    startStopButton.title = Constants.ButtonStartTitle
    cellBoard = CellBoard()
    imageView.image = renderer.render(cellBoard.cells)
  }

  @IBAction func startStop(startStopButton: UIBarButtonItem) {
    startStopButton.title = startStopButton.toggleTitle
    if startStopButton.title == Constants.ButtonStopTitle { turnOnAnimation() }
    else { turnOffAnimation() }
  }

  @IBAction func tapGestureHandler(gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .Ended:
      let touchPoint = gesture.locationInView(gesture.view) - renderer.bounds.origin
      let cell = Cell(
        x: Int(touchPoint.x / renderer.cellSize),
        y: Int(touchPoint.y / renderer.cellSize))
      cellBoard = cellBoard.toggle(cell)
      imageView.image = renderer.render(cellBoard.cells)
    default: break
    }
  }

  @IBAction func panGestureHandler(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .Began:
      turnOffAnimation()
      fallthrough
    case .Changed:
      let touchPoint = gesture.locationInView(gesture.view) - renderer.bounds.origin
      let cell = Cell(
        x: Int(touchPoint.x / renderer.cellSize),
        y: Int(touchPoint.y / renderer.cellSize))
      cellBoard = cellBoard.add(cell)
      let timeSinceLastFrame = NSDate.timestamp - lastFrameTimeStamp
      if timeSinceLastFrame > Constants.GestureFrameLength {
        imageView.image = renderer.render(cellBoard.cells)
        lastFrameTimeStamp = NSDate.timeIntervalSinceReferenceDate()
      }
    case .Ended:
      if animationIsRunning { turnOnAnimation() }
    default: break
    }
  }

  @IBAction func pinchGestureHandler(gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .Began:
      turnOffAnimation()
      fallthrough
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
      if timeSinceLastFrame > Constants.GestureFrameLength {
        imageView.image = renderer.render(cellBoard.cells)
        lastFrameTimeStamp = NSDate.timeIntervalSinceReferenceDate()
      }
      gesture.scale = 1
    case .Ended:
      if animationIsRunning { turnOnAnimation() }
      gesture.scale = 1
    default: break
    }
  }

  func drawNextFrame(_: NSTimer) {
    cellBoard = cellBoard.next
    imageView.image = renderer.render(cellBoard.cells)
  }

  private func turnOnAnimation() {
    timer?.invalidate()
    timer = NSTimer.scheduledTimerWithTimeInterval(Constants.FrameLength,
      target: self,
      selector: Selector("drawNextFrame:"),
      userInfo: nil,
      repeats: true)
  }

  private func turnOffAnimation() {
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
