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

  func add(cell: Cell) -> CellBoard {
    return CellBoard(livingCells: livingCells.union([cell]))
  }

  func toggle(cell: Cell) -> CellBoard {
    return CellBoard(livingCells: livingCells.exclusiveOr([cell]))
  }

  var next: CellBoard {
    let neighbors = self.neighbors
    return CellBoard(livingCells:
      survivors(live(neighbors)).union(newborns(dead(neighbors))))
  }

  private func survivors(liveCells: Set<Cell>) -> Set<Cell> {
    return liveCells.filter {
      let liveNeighborCount = self.liveNeighborCount($0)
      return liveNeighborCount == 2 || liveNeighborCount == 3
    }
  }

  private func newborns(deadCells: Set<Cell>) -> Set<Cell> {
    return deadCells.filter { self.liveNeighborCount($0) == 3 }
  }

  private func liveNeighborCount(cell: Cell) -> Int {
    return live(cell.neighbors).count
  }

  private func live(cells: Set<Cell>) -> Set<Cell> {
    return cells.intersect(livingCells)
  }

  private func dead(cells: Set<Cell>) -> Set<Cell> {
    return cells.subtract(livingCells)
  }

  private var neighbors: Set<Cell> {
    return livingCells.flatMap { $0.neighbors }
  }
}
