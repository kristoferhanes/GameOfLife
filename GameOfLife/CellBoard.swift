//
//  CellBoard.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

typealias Cells = Set<Cell>

struct CellBoard {
  let livingCells: Cells
}

extension CellBoard {

  init() {
    livingCells = Cells()
  }

  func addCell(cell: Cell) -> CellBoard {
    return CellBoard(livingCells: livingCells.union([cell]))
  }

  func next() -> CellBoard {
    var newCells = Cells()
    for cell in cellsToCheck {
      let livingNeighborCount = livingCells.intersect(cell.neighbors).count
      if livingNeighborCount == 3
        || (livingNeighborCount == 2 && livingCells.contains(cell)) {
        newCells.insert(cell)
      }
    }
    return CellBoard(livingCells: newCells)
  }

  private var cellsToCheck: Cells {
    var result = livingCells
    for cell in livingCells {
      result.unionInPlace(cell.neighbors)
    }
    return result
  }

}
