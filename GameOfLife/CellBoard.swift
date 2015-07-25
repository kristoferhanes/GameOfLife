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
    return CellBoard(livingCells: livingCells.union([cell]))
  }

  func next() -> CellBoard {
    let neighbors = livingCells.flatMap { $0.neighbors }
    let deadNeighbors = neighbors.subtract(livingCells)
    let livingNeighbors = livingCells.subtract(deadNeighbors)
    let newborns = deadNeighbors.filter {
      $0.neighbors.intersect(livingNeighbors).count == 3
    }
    let survivors = livingNeighbors.filter {
      let livingNeighborCount = $0.neighbors.intersect(livingNeighbors).count
      return livingNeighborCount == 2 || livingNeighborCount == 3
    }
    return CellBoard(livingCells: newborns.union(survivors))
  }
}
