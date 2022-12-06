//
//  PaddingLabel.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/12/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

final class PaddingLabel: UILabel {
    
    private var padding: UIEdgeInsets
    
    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
}
