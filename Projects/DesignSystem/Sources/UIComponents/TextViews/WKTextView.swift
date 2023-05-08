//
//  WKTextView.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/24.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class WKTextView: UITextView {
    
    // MARK: UIComponenets
    
    private let placeholderLabel: UILabel = UILabel()
    private let toolBar: UIToolbar = UIToolbar()
    private let doneButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        button.setTitleColor(.wkMainPurple, for: .normal)
        button.titleLabel?.font = .h4Sb
        return button
    }()
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    public init(isEditable: Bool) {
        super.init(frame: .zero, textContainer: nil)
        
        if isEditable {
            self.setDefaultStyle()
            self.setEditableStyle()
            self.setActiveStyle()
            self.setToolBar()
            self.setDoneButtonAction()
        } else {
            self.setDefaultStyle()
            self.setNoneEditableStyle()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Methods
    
    private func setToolBar() {
        let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: self.doneButton)
        let leftSpaceItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        self.toolBar.items = [leftSpaceItem, barButtonItem]
        self.toolBar.sizeToFit()
        self.inputAccessoryView = self.toolBar
    }
    
    private func setDoneButtonAction() {
        self.doneButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UI

extension WKTextView {
    private func setDefaultStyle() {
        self.backgroundColor = .wkWhite
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.wkBlack15.cgColor
        self.layer.borderWidth = 1
        self.textColor = .wkBlack
        self.font = .b1M
        self.autocorrectionType = .no
    }
    
    private func setEditableStyle() {
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.contentInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        self.verticalScrollIndicatorInsets.top = 10
        self.verticalScrollIndicatorInsets.bottom = 10
        self.verticalScrollIndicatorInsets.right = 4
    }
    
    private func setNoneEditableStyle() {
        self.isScrollEnabled = false
        self.isEditable = false
        self.inputAccessoryView = nil
        
        self.textContainerInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        self.textContainer.lineFragmentPadding = 0
        self.contentInset = .zero
    }
    
    private func setActiveStyle() {
        self.rx.didBeginEditing
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.layer.borderColor = UIColor.wkMainPurple.cgColor
                owner.layer.borderWidth = 2
            })
            .disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.layer.borderColor = UIColor.wkBlack15.cgColor
                owner.layer.borderWidth = 1
            })
            .disposed(by: disposeBag)
        
        self.rx.didScroll
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.scrollIndicators.vertical?.backgroundColor = .wkBlack15
            })
            .disposed(by: disposeBag)
    }
    
    private func setPlaceholderLayout() {
        self.textInputView.addSubview(placeholderLabel)
        
        self.placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(self.textContainerInset.top)
            make.left.equalToSuperview().inset(self.textContainerInset.left)
            make.right.equalToSuperview().inset(self.textContainerInset.right)
            make.bottom.equalToSuperview().inset(self.textContainerInset.bottom)
        }
    }
    
    public func setPlaceholder(text: String) {
        self.placeholderLabel.textColor = .wkBlack30
        self.placeholderLabel.font = .b1M
        self.placeholderLabel.numberOfLines = 0
        self.placeholderLabel.text = text
        self.setPlaceholderLayout()
        
        self.rx.text
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.text.isEmpty {
                    owner.placeholderLabel.isHidden = false
                } else {
                    owner.placeholderLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.text.isEmpty {
                    owner.placeholderLabel.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
}
