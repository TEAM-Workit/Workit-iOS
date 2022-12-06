//
//  WKRoundedButton.swift
//  DesignSystem
//
//  Created by madilyn on 2022/12/05.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit.UIButton

/**
 - 기본으로 MainPurple 컬러가 지정됩니다. 색 변경 시 enabledColor 파라미터를 이용해 주세요.
 */
public final class WKRoundedButton: UIButton {
    
    // MARK: - Initializer
    public init(enabledColor: UIColor) {
        super.init(frame: .zero)
        
        self.setDefaultUI(enabledColor: enabledColor)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setDefaultUI(enabledColor: .wkMainPurple)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        
        self.titleLabel?.font = UIFont.b1B
    }
}

// MARK: - UI

extension WKRoundedButton {
    private func setDefaultUI(enabledColor: UIColor) {
        self.makeRounded(radius: 5)
        self.titleLabel?.font = UIFont.b1B
        self.setTitleColor(UIColor.wkWhite, for: UIControl.State.normal)
        self.setTitleColor(UIColor.wkBlack45, for: UIControl.State.disabled)
        self.setBackgroundColor(enabledColor, for: UIControl.State.normal)
        self.setBackgroundColor(UIColor.wkBlack15, for: UIControl.State.disabled)
    }
}
