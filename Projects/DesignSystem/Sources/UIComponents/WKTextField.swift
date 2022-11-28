//
//  WKTextField.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/17.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class WKTextField: UITextField {
    
    // MARK: UIComponenets
    
    private let clearButton: UIButton = UIButton()
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultLayout()
        self.setDefaultStyle()
        self.setClearButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Methods
    
    private func setClearButton() {
        self.rx.text
            .orEmpty
            .distinctUntilChanged()
            .withUnretained(self)
            .subscribe(onNext: { (owner, changedText) in
                owner.clearButton.isHidden = changedText.isEmpty
            })
            .disposed(by: disposeBag)
        
        self.clearButton.rx.tap
            .withUnretained(self)
            .bind { (owner, _) in
                owner.text = ""
                owner.clearButton.isHidden = true
            }
            .disposed(by: disposeBag)
    }
    
    func removeClearButton() {
        self.clearButton.removeFromSuperview()
    }
}

// MARK: - UI

extension WKTextField {
    private func setDefaultLayout() {
        self.addSubviews([clearButton])
        
        self.clearButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(13)
            make.right.equalToSuperview().inset(10)
            make.width.equalTo(clearButton.snp.height)
        }
    }
    
    private func setDefaultStyle() {
        self.backgroundColor = .wkWhite
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.wkBlack15.cgColor
        self.layer.borderWidth = 1
        self.addLeftPadding(12)
        self.addRightPadding(44)
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.wkBlack30])
        self.textColor = .wkBlack
        self.font = .b1M
        
        self.setActiveStyle()
        self.setClearButtonStyle()
        self.returnKeyType = .done
    }
    
    private func setActiveStyle() {
        self.rx.controlEvent(.allEditingEvents)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.layer.borderColor = UIColor.wkMainPurple.cgColor
                owner.layer.borderWidth = 2
            })
            .disposed(by: disposeBag)
        
        self.rx.controlEvent(.editingDidEnd)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.layer.borderColor = UIColor.wkBlack15.cgColor
                owner.layer.borderWidth = 1
            })
            .disposed(by: disposeBag)
    }
    
    private func setClearButtonStyle() {
        self.clearButton.setImage(Image.wkTextFieldXButton.withRenderingMode(.alwaysOriginal), for: .normal)
    }
}
