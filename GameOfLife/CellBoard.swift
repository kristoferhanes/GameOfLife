//
//  CellBoard.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

struct CellBoard {
  fileprivate(set) var livingCells: Set<Cell> = []
}

extension CellBoard {

  mutating func add(_ cell: Cell) {
    livingCells.insert(cell)
  }

  mutating func toggle(_ cell: Cell) {
    livingCells.formSymmetricDifference([cell])
  }

  mutating func next() {

    func livingNeighborCount(of cell: Cell) -> Int {
      return neighbors(of: cell).intersection(livingCells).count
    }

    func isSurvivor(_ cell: Cell) -> Bool {
      let neighborCount = livingNeighborCount(of: cell)
      return neighborCount == 2 || neighborCount == 3
    }

    func isNewborn(_ cell: Cell) -> Bool {
      return livingNeighborCount(of: cell) == 3
    }

    func neighbors(of cell: Cell) -> Set<Cell> {
      struct Memo { static var neighbors: [Cell:Set<Cell>] = [:] }

      if let ns = Memo.neighbors[cell] { return ns }
      let x = cell.x
      let y = cell.y
      let result: Set = [
        Cell(x: x-1, y: y-1),
        Cell(x: x-1, y: y  ),
        Cell(x: x-1, y: y+1),
        Cell(x: x,   y: y-1),
        Cell(x: x,   y: y+1),
        Cell(x: x+1, y: y-1),
        Cell(x: x+1, y: y  ),
        Cell(x: x+1, y: y+1)
      ]
      Memo.neighbors[cell] = result
      return result
    }

    let allNeighbors = livingCells.flatMap(neighbors)
    let survivors = allNeighbors.intersection(livingCells).filter(isSurvivor)
    let newborns = allNeighbors.subtracting(livingCells).filter(isNewborn)

    livingCells = survivors.union(newborns)
    
  }
  
}
