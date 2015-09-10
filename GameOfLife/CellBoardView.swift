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
  let renderImage: (CGContext->())->UIImage

  init(bounds: CGRect, cellSize: CGFloat) {
    self.bounds = bounds
    self.cellSize = cellSize
    renderImage = drawToImage(self.bounds.size)
  }
}

extension CellBoardView {
  func pinch(location location: CGPoint, scale: CGFloat, bounds: CGRect) -> CellBoardView {
    return CellBoardView(
      bounds: CGRect(
        origin: (self.bounds.origin - location) * scale + location,
        size: bounds.size),
      cellSize: cellSize * scale)
  }

  func cellAtPoint(point: CGPoint) -> Cell {
    return Cell(point: pointInView(point) / cellSize)
  }

  func image(cells: Set<Cell>) -> UIImage {
    return renderImage { context in
      self.renderBackground(context)
      self.renderCells(context, cells)
    }
  }

  private func pointInView(point: CGPoint) -> CGPoint {
    return point - bounds.origin
  }

  private func renderBackground(context: CGContext) {
    UIColor.darkGrayColor().setFill()
    CGContextFillRect(context, CGRect(origin: CGPointZero, size: bounds.size))
  }

  private func renderCells(context: CGContext, _ cells: Set<Cell>) {
    UIColor.lightGrayColor().setFill()
    for cell in cells {
      CGContextFillRect(context, CGRect(
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
