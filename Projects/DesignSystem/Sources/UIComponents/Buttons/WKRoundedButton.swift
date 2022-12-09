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
    
    // MARK: Properties
    
    private var enabledColor: UIColor? {
        didSet {
            self.setBackgroundColor(enabledColor ?? .wkMainPurple, for: .normal)
        }
    }
    
    // MARK: - Initializer
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setDefaultUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override public func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        
        self.titleLabel?.font = UIFont.b1B
    }
    
    public func setEnabledColor(color: UIColor) {
        self.enabledColor = color
    }
}

// MARK: - UI

extension WKRoundedButton {
    private func setDefaultUI() {
        self.makeRounded(radius: 5)
        self.setEnabledColor(color: .wkMainPurple)
        self.setTitleColor(.wkWhite, for: .normal)
        self.setTitleColor(.wkBlack45, for: .disabled)
        self.setBackgroundColor(.wkBlack15, for: .disabled)
    }
}
