//
//  WKDateTextField.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/25.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

public final class WKDateTextField: WKTextField {
    
    // MARK: UIComponenets
    
    private let calendarImageView: UIImageView = UIImageView(image: Image.wkCalendar.withRenderingMode(.alwaysOriginal))
    private let button: UIButton = UIButton(type: .system)
    
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
    
    public func setDate(date: Date) {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateString: String = dateFormatter.string(from: date)
        self.text = dateString
    }
    
    public func setAction(_ closure: @escaping () -> ()) {
        self.button.addAction( UIAction { (action: UIAction) in closure() }, for: .touchUpInside)
    }
}

// MARK: - UI

extension WKDateTextField {
    private func setDefaultLayout() {
        self.removeClearButton()
        self.addSubviews([calendarImageView, button])
        
        self.calendarImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.trailing.equalToSuperview().inset(12)
            make.width.equalTo(calendarImageView.snp.height)
        }
        
        self.button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
