//
//  UILabel+.swift
//  Global
//
//  Created by 김혜수 on 2022/12/20.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UILabel

extension UILabel {
    /// 라벨에서 부분적으로 폰트를 바꾸는 메서드
    /// - Parameters:
    ///    - targetStrings: 폰트 바꿀 문자열 배열
    ///    - font: 바꿀 폰트
    public func changeFont(targetStrings: [String], font: UIFont) {
        let fullText = self.text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        for targetString in targetStrings {
            let range = (fullText as NSString).range(of: targetString)
            attributedString.addAttribute(.font, value: font, range: range)
        }
        self.attributedText = attributedString
    }
}
