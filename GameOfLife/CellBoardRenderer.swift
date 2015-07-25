//
//  CellBoardRenderer.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

struct CellBoardRenderer {
  let bounds: CGRect
  let cellSize: CGFloat
}

extension CellBoardRenderer {
  func render(cells: Set<Cell>) -> UIImage {
    return drawToUIImage(bounds.size) { context in
        self.drawBackground(context)
        self.drawCells(cells, context: context)
    }
  }

  func drawBackground(context: CGContext) {
    UIColor.whiteColor().set()
    CGContextFillRect(context, CGRect(origin: CGPoint(x: 0, y: 0), size: bounds.size))
  }

  func drawCells(cells: Set<Cell>, context: CGContext) {
    UIColor.darkGrayColor().set()
    for cell in cells {
      let x = CGFloat(cell.x) * cellSize + bounds.origin.x
      let y = CGFloat(cell.y) * cellSize + bounds.origin.y
      CGContextFillRect(context,
        CGRect(x: x, y: y, width: cellSize, height: cellSize))
    }
  }
}
