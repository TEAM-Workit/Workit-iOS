//
//  WithdrawalReasonView.swift
//  App
//
//  Created by 김혜수 on 2023/04/13.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

final class WithdrawalReasonView: UIView {
    
    enum Text {
        static let reason: String = "탈퇴하시려는 이유가 궁금해요."
    }
    
    private let reasonTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Text.reason
        label.font = .h4B
        label.textColor = .wkBlack
        return label
    }()
    
    private let reasonSelectButton: UIButton = {
        let button = UIButton()
        button.makeRounded(radius: 5)
        button.setTitle("이유 선택", for: .normal)
        button.layer.borderColor = UIColor.wkBlack15.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubviews([reasonTitleLabel, reasonSelectButton])
        
        self.reasonTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.reasonSelectButton.snp.makeConstraints { make in
            make.top.equalTo(self.reasonTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
    }
}
