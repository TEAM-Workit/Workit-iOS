//
//  WKEmptyCollectionViewCell.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/12/22.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

public final class WKEmptyCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setBackgroundColor() {
        self.contentView.backgroundColor = .clear
    }
}
