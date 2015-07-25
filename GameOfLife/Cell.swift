//
//  Cell.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

struct Cell { let x: Int, y: Int }

func == (lhs: Cell, rhs: Cell) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}

extension Cell: Hashable {
  var hashValue: Int {
    return (x << 16) ^ y
  }
}

extension Cell {
  var neighbors: Set<Cell> {
    struct Memo { static var neighbors = [Cell:Set<Cell>]() }

    if let n = Memo.neighbors[self] { return n }
    let result = Set([
      Cell(x: x-1, y: y-1),
      Cell(x: x-1, y: y  ),
      Cell(x: x-1, y: y+1),
      Cell(x: x,   y: y-1),
      Cell(x: x,   y: y+1),
      Cell(x: x+1, y: y-1),
      Cell(x: x+1, y: y  ),
      Cell(x: x+1, y: y+1)])
    Memo.neighbors[self] = result
    return result
  }
}
