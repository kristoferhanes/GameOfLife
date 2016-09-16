//
//  DrawToImage.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

func drawToImage(_ size: CGSize) -> ((CGContext)->()) -> UIImage {
  return { draw in
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    defer { UIGraphicsEndImageContext() }

    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
    UIGraphicsPushContext(context)
    draw(context)
    UIGraphicsPopContext()

    return UIGraphicsGetImageFromCurrentImageContext()!
  }
}
