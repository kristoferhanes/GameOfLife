//
//  Set-Extension.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 22.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

extension Set {
  func map<U>(transform: T->U) -> Set<U> {
    var result = Set<U>()
    for x in self {
      result.insert(transform(x))
    }
    return result
  }

  func flatMap<U>(transform: T->Set<U>) -> Set<U> {
    var result = Set<U>()
    for x in self {
      result.unionInPlace(transform(x))
    }
    return result
  }

  func filter(includeElement: T->Bool) -> Set<T> {
    var result = Set<T>()
    for x in self {
      if includeElement(x) { result.insert(x) }
    }
    return result
  }
}