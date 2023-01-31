//
//  CalendarBottomSheetTopView.swift
//  App
//
//  Created by 김혜수 on 2023/01/31.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

final class CalendarBottomSheetTopView: UIView {
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.wkX, for: .normal)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .h3M
        label.textColor = .wkBlack
        label.text = "2020.20.20"
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack30
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubviews([closeButton, dateLabel, lineView])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
