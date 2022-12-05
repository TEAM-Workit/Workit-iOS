//
//  WKTextFieldStyleButton.swift
//  DesignSystem
//
//  Created by madilyn on 2022/12/05.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

public class WKTextFieldStyleButton: UIButton {
    
    public enum Style {
        
        /// 기본 placeholder만 있는 디자인
        case defaultStyle
        
        /// placeholder엔 날짜가, 우측엔 calendar 아이콘이 있는 디자인
        case withCalendarStyle
    }
    
    // MARK: UIComponents
    
    private let textField: WKTextField = WKTextField()
    private let calendarImageView: UIImageView = UIImageView(image: Image.wkCalendar.withRenderingMode(.alwaysOriginal))
    
    // MARK: Initializer
    
    public init(style: Style = .defaultStyle) {
        super.init(frame: .zero)
        
        self.setDefaultLayout()
        self.setUI(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    public func setDate(date: Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateString: String = dateFormatter.string(from: date)
        self.textField.text = dateString
    }
    
    public func setPlaceholder(text: String) {
        self.textField.placeholder = text
    }
}

// MARK: - UI

extension WKTextFieldStyleButton {
    private func setDefaultLayout() {
        self.addSubview(textField)
        
        self.textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUI(style: Style) {
        self.textField.isUserInteractionEnabled = false
        
        if style == Style.withCalendarStyle {
            self.setCalendarImageLayout()
            self.setDate(date: Date())
        }
    }
    
    private func setCalendarImageLayout() {
        self.addSubview(calendarImageView)
        
        self.calendarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.trailing.equalToSuperview().inset(12)
            make.width.equalTo(calendarImageView.snp.height)
        }
    }
}
