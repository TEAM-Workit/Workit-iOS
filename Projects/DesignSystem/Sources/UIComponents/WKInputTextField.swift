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

class WKInputTextField: UITextField {
    
    // MARK: Components
    let clearButton: UIButton = UIButton()
    
    // MARK: Properties
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultStyle()
        self.setTextFieldClearBtn(textField: self, clearBtn: self.clearButton)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setDefaultStyle()
        self.setTextFieldClearBtn(textField: self, clearBtn: self.clearButton)
    }
    
    // MARK: Functions
    /// textField-btn 에 clear 기능 세팅하는 함수
    private func setTextFieldClearBtn(textField: UITextField, clearBtn: UIButton) {
        textField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { changedText in
                clearBtn.isHidden = changedText != "" ? false : true
            })
            .disposed(by: disposeBag)
        
        /// Clear 버튼 액션
        clearButton.rx.tap
            .bind {
                textField.text = ""
                clearBtn.isHidden = true
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UI
extension WKInputTextField {
    private func setClearButtonUI() {
        self.clearButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
    }
    
    private func setDefaultStyle() {
        self.addSubviews([clearButton])
        
        self.clearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(13)
            $0.right.equalToSuperview().inset(10)
            $0.width.equalTo(clearButton.snp.height)
        }
        
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 11
        self.addLeftPadding(17)
        self.addRightPadding(34)
//        self.font = .mumentH4M16
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "입력", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        self.textColor = .black
    }
}
