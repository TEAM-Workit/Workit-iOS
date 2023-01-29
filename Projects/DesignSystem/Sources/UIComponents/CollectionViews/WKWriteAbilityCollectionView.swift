//
//  WKWriteAbilityCollectionView.swift
//  DesignSystem
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

public final class WKWriteAbilityCollectionView: UICollectionView {
    
    // MARK: Initializer
    
    public init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.showsHorizontalScrollIndicator = false
        self.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}
