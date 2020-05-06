//
//  CatFeedLayout.swift
//  Pawsome
//
//  Created by Marentilo on 02.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class CatFeedLayout : UICollectionViewLayout {
    private let maxColumnNumber = 3
    private let cellPadding: CGFloat = 3
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    
    private var contentWidth: CGFloat {
      guard let collectionView = collectionView else { return 0 }
      let insets = collectionView.contentInset
      return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
      return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private func isSplitSection (section : Int) -> Bool {
        return section % 2 == 0
    }
    
    private func numberOfColumns(inSection section : Int) -> Int {
        return isSplitSection(section: section) ? 2 : maxColumnNumber
    }
    
    private func widthForSplitSection(section : Int) -> [CGFloat] {
        let minWidth = contentWidth / CGFloat(maxColumnNumber)
        let width = section % 4 == 0 ? [minWidth, minWidth * 2] : [minWidth * 2, minWidth]
        return width
    }
    
    override func prepare() {
        guard let collectionView = collectionView else {
            fatalError()
        }
        var yOffset: [CGFloat] = .init(repeating: 0, count: maxColumnNumber)
        
        for section in 0..<collectionView.numberOfSections {
            let columnsNumber = numberOfColumns(inSection: section)
            let columnWidth = isSplitSection(section: section) ? widthForSplitSection(section: section) : Array.init(repeating: contentWidth / CGFloat(maxColumnNumber), count: columnsNumber)
            var xOffset: [CGFloat] = []
            for column in 0..<columnsNumber {
                xOffset.append(column == 0 ? 0:  CGFloat(column) * columnWidth[column - 1])
            }
            var column = 0
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                let height = cellPadding * 2 + (columnWidth[column] > contentWidth / 2 ? columnWidth[column] + cellPadding * 2 : columnWidth[column] )
                let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth[column],
                               height: height)
            
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)              
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)
              
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                column = isSplitSection(section: section) && section % 4 != 0 && column == (columnsNumber - 1) ?  column : column < (columnsNumber - 1) ? (column + 1) : 0
            }
            for index in 0..<yOffset.count {
                yOffset[index] = yOffset[0]
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
              visibleLayoutAttributes.append(attributes)
            }
        }
      return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cache[indexPath.item]
    }
}

