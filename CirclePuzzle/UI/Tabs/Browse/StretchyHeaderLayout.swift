//
//  StretchyHeaderLayout.swift
//  CirclePuzzle
//
//  Created by Kevin Galarza on 6/3/24.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    let initialHeaderHeight: CGFloat = UIScreen.main.bounds.height / 4
    let minimumHeaderHeight: CGFloat = 120

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView, let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

        // Clone attributes to avoid caching issues
        let newAttributes = layoutAttributes.map { $0.copy() as! UICollectionViewLayoutAttributes }

        // Find the header attribute and adjust it
        for attributes in newAttributes {
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                adjustHeaderLayoutAttributes(attributes, collectionView: collectionView)
            }
        }
        return newAttributes
    }

    private func adjustHeaderLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes, collectionView: UICollectionView) {
        let contentOffsetY = collectionView.contentOffset.y
        
        if contentOffsetY < 0 {
            // Stretch the header when pulling down. Increase the header height by how much you pull down.
            let delta = min(initialHeaderHeight - contentOffsetY, initialHeaderHeight)
            attributes.frame = CGRect(x: 0, y: contentOffsetY, width: collectionView.frame.width, height: delta)
        } else {
            // Shrink the header when scrolling up but do not let it shrink beyond the minimum header height.
            let delta = min(contentOffsetY, initialHeaderHeight - minimumHeaderHeight)
            attributes.frame = CGRect(x: 0, y: contentOffsetY, width: collectionView.frame.width, height: initialHeaderHeight - delta)
        }
        attributes.zIndex = 1024  // Ensure header stays in front
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
