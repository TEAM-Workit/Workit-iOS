//
//  WithdrawalBottomView.swift
//  App
//
//  Created by 김혜수 on 2023/04/22.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import RxSwift
import RxCocoa
import SnapKit

final class WithdrawalBottomView: UIView {
    
    fileprivate let agreeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.wkUncheck, for: .normal)
        button.setImage(Image.wkCheck, for: .selected)
        button.setTitle("   안내사항을 모두 확인했으며, 탈퇴를 신청합니다.", for: .normal)
        button.setTitleColor(.wkBlack65, for: .normal)
        button.titleLabel?.font = .b1Sb
        button.contentHorizontalAlignment = .leading
        return button
    }()
    
    fileprivate let withdrawButton: WKRoundedButton = {
        let button = WKRoundedButton()
        button.setEnabledColor(color: .wkMainNavy)
        button.setTitle("탈퇴하기", for: .normal)
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
        self.addSubviews([agreeButton, withdrawButton])
        
        self.agreeButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(self.agreeButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    internal func changeAgreeButtonState(isSelected: Bool) {
        self.agreeButton.isSelected = isSelected
    }
}

extension Reactive where Base: WithdrawalBottomView {
    
    var agreeButtonDidTap: ControlEvent<Void> {
        return base.agreeButton.rx.tap
    }
}
