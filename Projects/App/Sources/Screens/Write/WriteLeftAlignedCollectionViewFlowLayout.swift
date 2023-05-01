//
//  WriteLeftAlignedCollectionViewFlowLayout.swift
//  App
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

final class WriteLeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let cellSpacing: CGFloat = 10
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        self.minimumLineSpacing = 10.0
        self.minimumInteritemSpacing = 8
        self.sectionInset = .zero
        
        let attributes: [UICollectionViewLayoutAttributes]? = super.layoutAttributesForElements(in: rect)?.map {
            $0.copy() as? UICollectionViewLayoutAttributes ?? UICollectionViewLayoutAttributes()
        } ?? []
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else { return }
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += (layoutAttribute.frame.width) + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
