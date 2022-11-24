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
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: Initializer
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setDefaultStyle()
        self.setActiveStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension WKTextView {
    private func setDefaultStyle() {
        self.backgroundColor = .wkWhite
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.wkBlack.cgColor
        self.layer.borderWidth = 1
        self.textColor = .wkBlack
        self.font = .b1M
        self.autocorrectionType = .no
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.contentInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        self.verticalScrollIndicatorInsets.top = 10
        self.verticalScrollIndicatorInsets.bottom = 10
        self.verticalScrollIndicatorInsets.right = 4
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
        }
    }
    
    public func setPlaceholder(placeholderText: String) {
        self.placeholderLabel.textColor = .wkBlack30
        self.placeholderLabel.font = .b1M
        self.placeholderLabel.text = placeholderText
        self.setPlaceholderLayout()
        
        self.rx.text
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.text.isEmpty {
                    owner.setPlaceholderLayout()
                } else {
                    owner.placeholderLabel.removeFromSuperview()
                }
            })
            .disposed(by: disposeBag)
        
        self.rx.didEndEditing
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.text.isEmpty {
                    owner.setPlaceholderLayout()
                }
            })
            .disposed(by: disposeBag)
    }
}
