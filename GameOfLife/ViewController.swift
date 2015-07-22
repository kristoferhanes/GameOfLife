//
//  ViewController.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

private struct Constants {
  static let CellSize: CGFloat = 10
  static let FrameRate = 1.0/10.0
}

class ViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!

  var cellBoard = CellBoard()
  var renderer: CellBoardRenderer!

  var timer: NSTimer?

  override func viewDidLoad() {
    renderer = initCellBoardRenderer()
  }

  @IBAction func startStop(startStopButton: UIBarButtonItem) {
    startStopButton.title = startStopButton.toggleTitle
    timer = NSTimer.scheduleTimer(timer,
      turnOn: startStopButton.title == "Start")
  }

  @IBAction func tapGestureHandler(gesture: UITapGestureRecognizer) {

  }

  @IBAction func panGestureHandler(gesture: UIPanGestureRecognizer) {

  }

  func drawNextFrame(timer: NSTimer) {
    imageView.image = renderer.render(cellBoard)
  }

  private func initCellBoardRenderer() -> CellBoardRenderer {
    return CellBoardRenderer(
      width: imageView.bounds.width / Constants.CellSize,
      height: imageView.bounds.height / Constants.CellSize,
      cellSize: Constants.CellSize)
  }

}


extension UIBarButtonItem {
  private var toggleTitle: String {
    switch title ?? "" {
    case "Start": return "Stop"
    case "Stop": return "Start"
    default: fatalError("Invalid button title")
    }
  }
}

extension NSTimer {
  private static func scheduleTimer(timer: NSTimer?, turnOn: Bool) -> NSTimer? {
    if turnOn {
      timer?.invalidate()
      return NSTimer.scheduledTimerWithTimeInterval(Constants.FrameRate,
        target: self,
        selector: Selector("drawNextFrame"),
        userInfo: nil,
        repeats: true)
    } else {
      timer?.invalidate()
      return nil
    }
  }
}