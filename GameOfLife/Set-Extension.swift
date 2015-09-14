//
//  Set-Extension.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 22.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

extension Set {
  func map<U>(transform: Element->U) -> Set<U> {
    var result = Set<U>(minimumCapacity: count)
    for x in self {
      result.insert(transform(x))
    }
    return result
  }

  func flatMap<U>(transform: Element->Set<U>) -> Set<U> {
    var result = Set<U>(minimumCapacity: count)
    for x in self {
      result.unionInPlace(transform(x))
    }
    return result
  }

  func filter(includeElement: Element->Bool) -> Set<Element> {
    var result = Set<Element>(minimumCapacity: count)
    for x in self {
      if includeElement(x) { result.insert(x) }
    }
    return result
  }
}
