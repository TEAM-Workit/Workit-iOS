//
//  WriteAbilityCollectionViewFlowLayout.swift
//  App
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

final class WriteAbilityCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: Initializer
    
    override init() {
        super.init()
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setUI() {
        self.scrollDirection = .horizontal
        self.minimumInteritemSpacing = 8.0
    }
}
