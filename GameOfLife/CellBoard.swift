//
//  CellBoard.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

struct CellBoard {
  private(set) var livingCells: Set<Cell> = []
}

extension CellBoard {

  mutating func add(cell: Cell) {
    livingCells.insert(cell)
  }

  mutating func toggle(cell: Cell) {
    livingCells.exclusiveOrInPlace([cell])
  }

  mutating func next() {

    func livingNeighborCount(cell: Cell) -> Int {
      return cell.neighbors.intersect(livingCells).count
    }

    func livingCellSurvives(cell: Cell) -> Bool {
      let neighborCount = livingNeighborCount(cell)
      return neighborCount == 2 || neighborCount == 3
    }

    func isBorn(cell: Cell) -> Bool {
      return livingNeighborCount(cell) == 3
    }

    let allNeighbors = livingCells.flatMap { $0.neighbors }
    let livingNeighbors = allNeighbors.intersect(livingCells)
    let deadNeighbors = allNeighbors.subtract(livingCells)
    let survivors = livingNeighbors.filter(livingCellSurvives)
    let newborns = deadNeighbors.filter(isBorn)

    livingCells = survivors.union(newborns)
    
  }

}
