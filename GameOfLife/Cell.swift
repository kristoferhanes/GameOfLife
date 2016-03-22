//
//  Cell.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

struct Cell { let x: Int, y: Int }

extension Cell: Hashable {
  var hashValue: Int {
    return (x << 16) ^ y
  }
}

func == (lhs: Cell, rhs: Cell) -> Bool {
  return lhs.x == rhs.x && lhs.y == rhs.y
}
