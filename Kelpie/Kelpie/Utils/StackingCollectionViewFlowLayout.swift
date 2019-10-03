//
//  StackingCollectionViewFlowLayout.swift
//  Kelpie
//
//  Created by Elliott Kipper on 10/2/19.
//  Copyright © 2019 Kip. All rights reserved.
//

import UIKit

class StackingCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - ivars
    
    // MARK: - Initializers
    override init() {
        super.init()
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        //No-op so far
    }
    
    // MARK: - UICollectionViewFlowLayout
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let traits = super.layoutAttributesForElements(in: rect)
        guard let collectionView = self.collectionView else {
            return traits
        }
        let tRange: CGFloat = self.itemSize.height - self.minimumInteritemSpacing
        traits?.forEach {
            let convertedY = $0.frame.origin.y - collectionView.contentOffset.y - self.sectionInset.top
            let newY = max(-convertedY, 0.0)
            let t = 1.0 - min(1.0, max(0.0, ((tRange + convertedY) / tRange)))
            let scaleT = max(0.1, 1.0 - (t / 10.0))
            let alphaT = 1.0 - sqrt(t)
            $0.transform = CGAffineTransform.identity.translatedBy(x: 0.0, y: newY - (10.0 * sqrt(t)))
                .scaledBy(x: scaleT, y: scaleT)
            $0.alpha = alphaT
        }
        return traits
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView,
            collectionView.contentOffset.y > 0 else {
            return false
        }
        return true
    }

}
