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
    
    /// 특정 문자열 컬러, 폰트 변경하는 메서드
    /// - Parameters:
    ///    - targetStrings: 폰트 바꿀 문자열 배열
    ///    - font: 바꿀 폰트
    ///    - color: 바꿀 색상
    public func setFontColor(to targetString: String, font: UIFont, color: UIColor) {
        if let labelText = self.text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(
                attributedString: self.attributedText ?? NSAttributedString(string: labelText)
            )
            
            attributedString.addAttribute(
                .font,
                value: font,
                range: (labelText as NSString).range(of: targetString)
            )
            
            attributedString.addAttribute(
                .foregroundColor,
                value: color,
                range: (labelText as NSString).range(of: targetString)
            )
            
            attributedText = attributedString
        }
    }
    
    public func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(
            for: point,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )
        return index
    }
    
    /// 행간 설정
    public func setLineSpacing(lineSpacing: CGFloat) {
        if let text = self.text {
            let attributedStr = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attributedStr.addAttribute(
                NSAttributedString.Key.paragraphStyle,
                value: style,
                range: NSRange(location: 0, length: attributedStr.length))
            self.attributedText = attributedStr
        }
    }
    
    /// 밑줄 추가
    public func setUnderLineAttributes(lineTexts: [String]) {
        guard let title = self.text else { return }
        let attributeString = NSMutableAttributedString(string: title)
        
        for text in lineTexts {
            attributeString.addAttribute(
                NSAttributedString.Key.underlineStyle,
                value: 1,
                range: (title as NSString).range(of: text)
            )
        }
        self.attributedText = attributeString
    }
}
