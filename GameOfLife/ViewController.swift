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
  static let FrameLength = 1.0 / 23.0
  static let AnimationFrameLength = 1.0 / 30.0
  static let ButtonStopTitle = "Stop"
  static let ButtonStartTitle = "Start"
}

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var startStopButton: UIBarButtonItem!

  fileprivate var cellBoard = CellBoard()
  fileprivate var cellBoardView = CellBoardView(
    bounds: CGRect(),
    cellSize: Constants.defaultCellSize)

  fileprivate var timer: Timer?

  fileprivate var lastFrameTimeStamp = Date.timestamp

  fileprivate var timeSinceLastFrame: TimeInterval {
    return Date.timestamp - lastFrameTimeStamp
  }

  fileprivate var animationIsRunning: Bool {
    return startStopButton.title == Constants.ButtonStopTitle
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let newOrigin = imageView.bounds.origin + cellBoardView.bounds.origin
    cellBoardView = CellBoardView(
      bounds: CGRect(origin: newOrigin, size: imageView.bounds.size),
      cellSize: cellBoardView.cellSize)
    imageView.image = cellBoardView.image(cellBoard.livingCells)
  }

  @IBAction func clearCells(_: UIBarButtonItem) {
    turnOffAnimation()
    startStopButton.title = Constants.ButtonStartTitle
    cellBoard = CellBoard()
    imageView.image = cellBoardView.image(cellBoard.livingCells)
  }

  @IBAction func startStop(_ startStopButton: UIBarButtonItem) {
    startStopButton.title = startStopButton.toggledTitle
    if animationIsRunning { turnOnAnimation() }
    else { turnOffAnimation() }
  }

  @IBAction func tapGestureHandler(_ gesture: UITapGestureRecognizer) {
    switch gesture.state {
    case .ended:
      cellBoard.toggle(cellBoardView.cellAtPoint(gesture.locationInView))
      imageView.image = cellBoardView.image(cellBoard.livingCells)
    default: break
    }
  }

  @IBAction func panGestureHandler(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      turnOffAnimation()
      fallthrough
    case .changed:
      cellBoard.add(cellBoardView.cellAtPoint(gesture.locationInView))
      imageView.image = nextCellBoardImageFrame
    case .ended:
      if animationIsRunning { turnOnAnimation() }
    default: break
    }
  }

  @IBAction func pinchGestureHandler(_ gesture: UIPinchGestureRecognizer) {
    switch gesture.state {
    case .began:
      turnOffAnimation()
      fallthrough
    case .changed:
      cellBoardView = cellBoardView.pinch(
        location: gesture.locationInView,
        scale: gesture.scale,
        bounds: imageView.bounds)
      imageView.image = nextCellBoardImageFrame
      gesture.scale = 1
    case .ended:
      gesture.scale = 1
      if animationIsRunning { turnOnAnimation() }
    default: break
    }
  }

  fileprivate var nextCellBoardImageFrame: UIImage? {
    var result = imageView.image
    if timeSinceLastFrame >= Constants.AnimationFrameLength {
      result = cellBoardView.image(cellBoard.livingCells)
      lastFrameTimeStamp = Date.timestamp
    }
    return result
  }

  func drawNextFrame(_: Timer) {
    cellBoard.next()
    imageView.image = cellBoardView.image(cellBoard.livingCells)
  }

  fileprivate func turnOnAnimation() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(timeInterval: Constants.FrameLength,
                                                   target: self,
                                                   selector: #selector(ViewController.drawNextFrame(_:)),
                                                   userInfo: nil,
                                                   repeats: true)
  }

  fileprivate func turnOffAnimation() {
    timer?.invalidate()
    timer = nil
  }
}

extension Date {
  fileprivate static var timestamp: TimeInterval {
    return Date.timeIntervalSinceReferenceDate
  }
}

extension UIBarButtonItem {
  fileprivate var toggledTitle: String {
    switch title ?? "" {
    case Constants.ButtonStartTitle: return Constants.ButtonStopTitle
    case Constants.ButtonStopTitle: return Constants.ButtonStartTitle
    default: fatalError("Invalid button title")
    }
  }
}

extension UIGestureRecognizer {
  fileprivate var locationInView: CGPoint {
    return location(in: view)
  }
}
