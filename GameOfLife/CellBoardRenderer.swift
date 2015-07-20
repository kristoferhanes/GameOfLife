//
//  CellBoardRenderer.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

struct CellBoardRenderer {
  let width: CGFloat
  let height: CGFloat
  let cellSize: CGFloat
}

extension CellBoardRenderer {

  func render(cells: CellBoard) -> UIImage {
    return drawToUIImage(width: width * cellSize, height: height * cellSize) { context in

      UIColor.whiteColor().set()
      CGContextFillRect(context,
        CGRect(
          x: 0,
          y: 0,
          width: self.width * self.cellSize,
          height: self.height * self.cellSize))

      UIColor.blackColor().set()
      for cell in cells.livingCells {
        CGContextFillRect(context,
          CGRect(
            x: CGFloat(cell.x) * self.cellSize,
            y: CGFloat(cell.y) * self.cellSize,
            width: self.cellSize,
            height: self.cellSize))
      }

    }
  }

}
