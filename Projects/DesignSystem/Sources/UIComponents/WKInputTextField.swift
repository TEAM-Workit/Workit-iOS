//
//  WKInputTextField.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/17.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public class WKInputTextField: UITextField {
    
    // MARK: Components
    private let clearButton: UIButton = UIButton()
    
    // MARK: Properties
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultLayout()
        self.setDefaultStyle()
        self.setTextFieldClearBtn(textField: self, targetClearButton: self.clearButton)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Functions
    /// textField-btn 에 clear 기능 세팅하는 함수
    private func setTextFieldClearBtn(textField: UITextField, targetClearButton: UIButton) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                targetClearButton.isHidden = changedText != "" ? false : true
            }).disposed(by: disposeBag)
        
        /// Clear 버튼 액션
        targetClearButton.rx.tap
            .bind {
                textField.text = ""
                targetClearButton.isHidden = true
            }.disposed(by: disposeBag)
    }
}

// MARK: - UI
extension WKInputTextField {
    private func setTextFieldActiveStyle() {
        self.rx.controlEvent(.allEditingEvents)
            .subscribe(onNext: { _ in
                self.layer.borderColor = UIColor.purple.cgColor
                self.layer.borderWidth = 2
            }).disposed(by: disposeBag)
        
        self.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { _ in
                self.layer.borderColor = UIColor.lightGray.cgColor
                self.layer.borderWidth = 1
            }).disposed(by: disposeBag)
    }
    
    private func setClearButtonUI() {
        self.clearButton.setImage(UIImage(systemName: "x.circle.fill")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
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
        // TODO: font, color 변경
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.addLeftPadding(12)
        self.addRightPadding(44)
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "placeholder", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        self.textColor = .black
        
        self.setTextFieldActiveStyle()
        self.setClearButtonUI()
        self.returnKeyType = .done
    }
}
