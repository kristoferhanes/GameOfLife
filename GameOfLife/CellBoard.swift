//
//  CellBoard.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

struct CellBoard {
  let cells: Set<Cell>
}

extension CellBoard {
  init() { cells = Set<Cell>() }

  func add(cell: Cell) -> CellBoard {
    return CellBoard(cells: cells.union([cell]))
  }

  func toggle(cell: Cell) -> CellBoard {
    return CellBoard(cells: cells.exclusiveOr([cell]))
  }

  var next: CellBoard {
    return CellBoard(cells:
      survivors(live(neighbors)).union(newborns(dead(neighbors))))
  }

  private func survivors(liveCells: Set<Cell>) -> Set<Cell> {
    return liveCells.filter
      { self.liveNeighborCount($0) == 2 || self.liveNeighborCount($0) == 3 }
  }

  private func liveNeighborCount(cell: Cell) -> Int {
    return live(cell.neighbors).count
  }

  private func newborns(deadCells: Set<Cell>) -> Set<Cell> {
    return deadCells.filter { self.liveNeighborCount($0) == 3 }
  }

  private func live(cs: Set<Cell>) -> Set<Cell> {
    return cs.intersect(cells)
  }

  private func dead(cs: Set<Cell>) -> Set<Cell> {
    return cs.subtract(cells)
  }

  private var neighbors: Set<Cell> {
    return cells.flatMap { $0.neighbors }
  }
}
