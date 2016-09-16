//
//  CellBoardView.swift
//  GameOfLife
//
//  Created by Kristofer Hanes on 2015 07 20.
//  Copyright (c) 2015 Kristofer Hanes. All rights reserved.
//

import UIKit

struct CellBoardView {
  let bounds: CGRect
  let cellSize: CGFloat
  let renderImage: ((CGContext)->())->UIImage

  init(bounds: CGRect, cellSize: CGFloat) {
    self.bounds = bounds
    self.cellSize = cellSize
    renderImage = drawToImage(self.bounds.size)
  }
}

extension CellBoardView {
  func pinch(location: CGPoint, scale: CGFloat, bounds: CGRect) -> CellBoardView {
    return CellBoardView(
      bounds: CGRect(
        origin: (self.bounds.origin - location) * scale + location,
        size: bounds.size),
      cellSize: cellSize * scale)
  }

  func cellAtPoint(_ point: CGPoint) -> Cell {
    return Cell(point: pointInView(point) / cellSize)
  }

  func image(_ cells: Set<Cell>) -> UIImage {
    return renderImage { context in
      self.renderBackground(context)
      self.renderCells(context, cells)
    }
  }

  fileprivate func pointInView(_ point: CGPoint) -> CGPoint {
    return point - bounds.origin
  }

  fileprivate func renderBackground(_ context: CGContext) {
    UIColor.darkGray.setFill()
    context.fill(CGRect(origin: CGPoint.zero, size: bounds.size))
  }

  fileprivate func renderCells(_ context: CGContext, _ cells: Set<Cell>) {
    UIColor.lightGray.setFill()
    for cell in cells {
      context.fill(CGRect(
        origin: CGPoint(cell: cell) * cellSize + bounds.origin,
        size: CGSize(size: cellSize)))
    }
  }
}

extension Cell {
  init(point: CGPoint) {
    x = Int(point.x)
    y = Int(point.y)
  }
}

extension CGPoint {
  init(cell: Cell) {
    x = CGFloat(cell.x)
    y = CGFloat(cell.y)
  }
}

extension CGSize {
  init(size: CGFloat) {
    width = size
    height = size
  }
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func * (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  return CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}

func / (lhs: CGPoint, rhs: CGFloat) -> CGPoint {
  return CGPoint(x: lhs.x / rhs, y: lhs.y / rhs)
}
