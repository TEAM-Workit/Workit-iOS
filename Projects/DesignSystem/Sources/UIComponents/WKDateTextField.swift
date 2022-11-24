//
//  WKDateTextField.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/25.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import SnapKit

public final class WKDateTextField: WKTextField {
    
    // MARK: UIComponenets
    
    private let calendarImageView: UIImageView = UIImageView(image: Image.wkCalendar.withRenderingMode(.alwaysOriginal))
    let selectDateButton: UIButton = UIButton(type: .system)
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultLayout()
        self.setDate(date: Date())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    func setDate(date: Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateString: String = dateFormatter.string(from: date)
        self.text = dateString
    }
}

// MARK: - UI

extension WKDateTextField {
    private func setDefaultLayout() {
        self.clearButton.removeFromSuperview()
        self.addSubviews([calendarImageView, selectDateButton])
        
        self.calendarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.right.equalToSuperview().inset(12)
            make.width.equalTo(calendarImageView.snp.height)
        }
        self.selectDateButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
