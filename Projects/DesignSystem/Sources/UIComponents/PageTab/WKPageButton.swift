//
//  WKPageButton.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/12/06.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

internal final class WKPageButton: UIButton {
    
    // MARK: - UIComponents
    
    private var selectedTitleColor: UIColor!
    private var defaultTitleColor: UIColor!

    // MARK: - Properties
    
    override var isSelected: Bool {
        didSet {
            self.changeButtonStyle()
        }
    }

    // MARK: - Initializer

    public init(
        selectedTitleColor: UIColor = UIColor.wkMainPurple,
        defaultTitleColor: UIColor = UIColor.wkBlack45,
        backgroundColor: UIColor = UIColor.wkWhite,
        titleFont: UIFont = UIFont.h3Sb
    ) {
        super.init(frame: .zero)
        
        self.selectedTitleColor = selectedTitleColor
        self.defaultTitleColor = defaultTitleColor
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = titleFont
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    
    private func changeButtonStyle() {
        self.setTitleColor(isSelected ? selectedTitleColor : defaultTitleColor, for: .normal)
    }
    
}
