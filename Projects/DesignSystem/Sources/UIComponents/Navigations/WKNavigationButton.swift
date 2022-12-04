//
//  WKNavigationButton.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit.UIButton

/// WKNavigationController와 함께 사용할 버튼입니다.
/// 텍스트 버튼 사용 시 버튼 상태에 따라 컬러값이 디폴트로 지정되어있고
/// 이미지 버튼 사용 시 이미지를 디자인 시스템에 맞게 리사이즈 합니다.
public final class WKNavigationButton: UIButton {
    
    // MARK: - Properties
    
    public override var isEnabled: Bool {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var titleColor: UIColor = UIColor.wkMainPurple
    public var disableColor: UIColor = UIColor.wkBlack30
    
    // MARK: - Initializer
    
    /// - Parameters:
    ///    - image: 버튼에 사용할 이미지 에셋을 설정해줍니다.
    public init(image: UIImage?) {
        super.init(frame: .zero)
        
        self.setImage(
            image?.resize(to: CGSize(width: 24, height: 24))
                .withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }
    
    /// - Parameters:
    ///    - text: 버튼에 사용할 텍스트를 설정해줍니다.
    public init(text: String?) {
        super.init(frame: .zero)
        
        self.setTitle(text, for: .normal)
        self.setStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    /// 버튼의  텍스트를 설정합니다.
    /// 휴먼 에러를 방지하기 위해 이미 이미지를 세팅한 버튼인 경우 early return 해줍니다.
    /// setImage와 동시에 사용하지 않습니다.
    public override func setTitle(
        _ title: String?,
        for state: UIControl.State
    ) {
        if self.image(for: .normal) != nil
            || self.image(for: .highlighted) != nil
            || self.image(for: .disabled) != nil
            || self.image(for: .selected) != nil
            || self.image(for: .focused) != nil
            || self.image(for: .application) != nil
            || self.image(for: .reserved) != nil {
            return
        }

        super.setTitle(title, for: state)
    }
    
    /// 버튼의  이미지를 설정합니다.
    /// 휴먼 에러를 방지하기 위해 이미 텍스트를 세팅한 버튼인 경우 early return 해줍니다.
    /// setTitle과 동시에 사용하지 않습니다.
    public override func setImage(
        _ image: UIImage?,
        for state: UIControl.State
    ) {
        if self.title(for: .normal) != nil
            || self.title(for: .highlighted) != nil
            || self.title(for: .disabled) != nil
            || self.title(for: .selected) != nil
            || self.title(for: .highlighted) != nil
            || self.title(for: .focused) != nil
            || self.title(for: .application) != nil
            || self.title(for: .reserved) != nil {
            return
        }

        super.setImage(image, for: state)
    }
    
    private func setStyle() {
        self.titleLabel?.font = UIFont.h3Sb
    }
    
    /// 버튼의 상태에 따라 컬러를 변경합니다.
    private func setColor() {
        self.setTitleColor(self.isEnabled ? self.titleColor : self.disableColor, for: .normal)
    }
    
    /// 버튼의 Enable 상태가 변경될 경우 View를 다시 그립니다.
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setColor()
    }
}
