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
  var cellBoardView = CellBoardView(
    bounds: CGRect(),
    cellSize: Constants.defaultCellSize)

  var timer: NSTimer?

  var lastFrameTimeStamp = NSDate.timestamp

  var animationIsRunning: Bool {
    return startStopButton.title == Constants.ButtonStopTitle
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    cellBoardView = CellBoardView(
      bounds: imageView.bounds,
      cellSize: Constants.defaultCellSize)
    imageView.image = cellBoardView.render(cellBoard.cells)
  }

  @IBAction func clearCells(_: UIBarButtonItem) {
    turnOffAnimation()
    startStopButton.title = Constants.ButtonStartTitle
    cellBoard = CellBoard()
    imageView.image = cellBoardView.render(cellBoard.cells)
  }

  @IBAction func startStop(startStopButton: UIBarButtonItem) {
    startStopButton.title = startStopButton.toggleTitle
    if startStopButton.title == Constants.ButtonStopTitle { turnOnAnimation() }
    else { turnOffAnimation() }
  }

  @IBAction func tapGestureHandler(gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .Ended:
      cellBoard = cellBoard.toggle(
        cellBoardView.cellAtPoint(gesture.locationInView(gesture.view)))
      imageView.image = cellBoardView.render(cellBoard.cells)
    default: break
    }
  }

  @IBAction func panGestureHandler(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .Began:
      turnOffAnimation()
      fallthrough
    case .Changed:
      cellBoard = cellBoard.add(
        cellBoardView.cellAtPoint(gesture.locationInView(gesture.view)))
      let timeSinceLastFrame = NSDate.timestamp - lastFrameTimeStamp
      if timeSinceLastFrame > Constants.GestureFrameLength {
        imageView.image = cellBoardView.render(cellBoard.cells)
        lastFrameTimeStamp = NSDate.timestamp
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
      let newCellSize = cellBoardView.cellSize * scale
      let x = (cellBoardView.bounds.origin.x - location.x) * scale + location.x
      let y = (cellBoardView.bounds.origin.y - location.y) * scale + location.y
      let newBounds = CGRect(
        origin: CGPoint(x: x, y: y),
        size: imageView.bounds.size)
      cellBoardView = CellBoardView(bounds: newBounds, cellSize: newCellSize)
      let timeSinceLastFrame = NSDate.timestamp - lastFrameTimeStamp
      if timeSinceLastFrame > Constants.GestureFrameLength {
        imageView.image = cellBoardView.render(cellBoard.cells)
        lastFrameTimeStamp = NSDate.timestamp
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
    imageView.image = cellBoardView.render(cellBoard.cells)
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
