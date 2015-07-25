//
//  Future.swift
//  Future
//
//  Created by Kristofer Hanes on 2015 06 11.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import Foundation

enum QOS {
  case Main
  case UserInteractive
  case UserInitiated
  case Utility
  case Background

  private var queue: dispatch_queue_t {
    switch self {
    case .Main:
      return dispatch_get_main_queue()
    case .UserInteractive:
      return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
    case .UserInitiated:
      return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
    case .Utility:
      return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)
    case .Background:
      return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)
    }
  }
}

struct Future<T> {
  typealias Completion = T->()
  typealias Operation = Completion->()

  private let operation: Operation

  init(_ value: T) {
    self.init(operation: { completion in completion(value) })
  }

  init(qos: QOS = .Utility, operation: Operation) {
    self.operation = { completion in dispatch_async(qos.queue) { operation(completion) } }
  }

  func start(completion: Completion) {
    operation { result in dispatch_async(QOS.Main.queue) { completion(result) } }
  }
}

extension Future {
  func map<U>(f: T->U) -> Future<U> {
    return Future<U> { completion in self.operation { result in completion(f(result)) } }
  }

  func flatMap<U>(f: T->Future<U>) -> Future<U> {
    return Future<U> { completion in self.operation { result in f(result).start(completion) } }
  }
}

func futureDataFromURL(url: NSURL?, withQOS qos: QOS = .Utility) -> Future<NSData?> {
  return Future(qos: qos) { completion in completion(url.flatMap { NSData(contentsOfURL: $0) }) }
}

