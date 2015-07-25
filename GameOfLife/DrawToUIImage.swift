//
//  DrawToUIImage.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

func drawToUIImage(size: CGSize, draw: CGContext->()) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    
    let context = UIGraphicsGetCurrentContext()
    UIGraphicsPushContext(context)

    draw(context)

    UIGraphicsPopContext()
    let result = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return result
}
