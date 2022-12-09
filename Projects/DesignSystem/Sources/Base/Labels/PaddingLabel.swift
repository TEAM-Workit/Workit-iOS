//
//  PaddingLabel.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/12/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

public class PaddingLabel: UILabel {
    
    // MARK: - Properties
    
    private var padding: UIEdgeInsets
    
    // MARK: - Initializer
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
