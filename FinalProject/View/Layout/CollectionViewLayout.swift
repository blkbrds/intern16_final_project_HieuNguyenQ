//
//  CollectionViewLayout.swift
//  theCollectors
//
//  Created by hieungq on 8/3/20.
//  Copyright © 2020 hieungq. All rights reserved.
//

import UIKit

protocol CollectionViewLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, sizeOfImageAtIndexPath indexPath: IndexPath) -> CGSize
}

final class CollectionViewLayout: UICollectionViewLayout {
    weak var delegate: CollectionViewLayoutDelegate!

    var numberOfColumn = 3
    private var cellPadding: CGFloat = 8
    private var cache: [UICollectionViewLayoutAttributes] = []

    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else { return }

        let columnWidth = contentWidth / CGFloat(numberOfColumn)

        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumn {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumn)

        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let imageSize = delegate.collectionView(collectionView, sizeOfImageAtIndexPath: indexPath)

            let columnHeight = imageSize.height * columnWidth / imageSize.width + cellPadding * 2

            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: columnHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + columnHeight

            column = column < (numberOfColumn - 1) ? column + 1 : 0
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

    func clearCache() {
        self.cache = [UICollectionViewLayoutAttributes]()
    }
}
