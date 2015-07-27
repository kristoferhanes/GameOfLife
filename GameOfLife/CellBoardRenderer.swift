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
    return drawToImage(bounds.size) { context in
      self.drawBackground(context)
      self.drawCells(cells, context)
    }
  }

  private func drawBackground(context: CGContext) {
    UIColor.darkGrayColor().setFill()
    CGContextFillRect(context, CGRect(
      origin: CGPoint(x: 0, y: 0),
      size: bounds.size))
  }

  private func drawCells(cells: Set<Cell>, _ context: CGContext) {
    UIColor.lightGrayColor().setFill()
    for cell in cells {
      CGContextFillRect(context, CGRect(
        x: CGFloat(cell.x) * cellSize + bounds.origin.x,
        y: CGFloat(cell.y) * cellSize + bounds.origin.y,
        width: cellSize,
        height: cellSize))
    }
  }
}
