//
//  ViewController.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

private struct Constants {
  static let defaultCellSize = CGFloat(16)
  static let FrameLength = 1.0 / 20.0
  static let AnimationFrameLength = 1.0 / 30.0
  static let ButtonStopTitle = "Stop"
  static let ButtonStartTitle = "Start"
}

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var startStopButton: UIBarButtonItem!

  private var cellBoard = CellBoard()
  private var cellBoardView = CellBoardView(
    bounds: CGRect(),
    cellSize: Constants.defaultCellSize)

  private var timer: NSTimer?

  private var lastFrameTimeStamp = NSDate.timestamp

  private var timeSinceLastFrame: NSTimeInterval {
    return NSDate.timestamp - lastFrameTimeStamp
  }

  private var animationIsRunning: Bool {
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
    startStopButton.title = startStopButton.toggledTitle
    if animationIsRunning { turnOnAnimation() }
    else { turnOffAnimation() }
  }

  @IBAction func tapGestureHandler(gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .Ended:
      cellBoard = cellBoard.toggle(
        cellBoardView.cellAtPoint(gesture.locationInView))
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
        cellBoardView.cellAtPoint(gesture.locationInView))
      imageView.image = nextCellBoardImageFrame
    case .Ended:
      if animationIsRunning { turnOnAnimation() }
    default: break
    }
  }

  @IBAction func pinchGestureHandler(gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .Began, .Changed:
      cellBoardView = cellBoardView.pinch(
        location: gesture.locationInView,
        scale: gesture.scale,
        bounds: imageView.bounds)
      imageView.image = nextCellBoardImageFrame
      gesture.scale = 1
    case .Ended:
      gesture.scale = 1
    default: break
    }
  }

  private var nextCellBoardImageFrame: UIImage? {
    var result = imageView.image
    if timeSinceLastFrame >= Constants.AnimationFrameLength {
      result = cellBoardView.render(cellBoard.cells)
      lastFrameTimeStamp = NSDate.timestamp
    }
    return result
  }

  func drawNextFrame(_: NSTimer) {
    cellBoard = cellBoard.next
    imageView.image = nextCellBoardImageFrame
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
  private var toggledTitle: String {
    switch title ?? "" {
    case Constants.ButtonStartTitle: return Constants.ButtonStopTitle
    case Constants.ButtonStopTitle: return Constants.ButtonStartTitle
    default: fatalError("Invalid button title")
    }
  }
}

extension UIGestureRecognizer {
  private var locationInView: CGPoint {
    return locationInView(view)
  }
}
