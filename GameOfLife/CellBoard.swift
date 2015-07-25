//
//  CellBoard.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

struct CellBoard {
  let livingCells: Set<Cell>
}

extension CellBoard {
  init() { livingCells = Set<Cell>() }

  func addCell(cell: Cell) -> CellBoard {
    var cells = livingCells
    cells.insert(cell)
    return CellBoard(livingCells: cells)
  }

  func next() -> CellBoard {
    let potantialCells = livingCells.flatMap { $0.neighbors.union([$0]) }
    let result = potantialCells.filter { cell in
      cell.shouldLive(
        isAlive: self.livingCells.contains(cell),
        neightborCount: self.livingCells.intersect(cell.neighbors).count)
    }
    return CellBoard(livingCells: result)
  }

}
