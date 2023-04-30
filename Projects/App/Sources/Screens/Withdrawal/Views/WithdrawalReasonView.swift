//
//  WithdrawalReasonView.swift
//  App
//
//  Created by 김혜수 on 2023/04/13.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class WithdrawalReasonView: UIView {
    
    enum Text {
        static let reason: String = "탈퇴하시려는 이유가 궁금해요."
    }
    
    private let reasons: [String] = [
        "기록하기가 귀찮아요",
        "기록하는 방법이 불편하고 어려워요",
        "알림이 너무 많이 와요",
        "새 계정을 만들고 싶어요",
        "지난 기록을 보기가 불편해요",
        "더 이상 이직 준비를 하지 않아요"
    ]
    
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
        button.setTitle("    이유 선택", for: .normal)
        button.setTitleColor(.wkBlack30, for: .normal)
        button.titleLabel?.font = .b1M
        button.contentHorizontalAlignment = .leading
        button.layer.borderColor = UIColor.wkBlack15.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let etcReasonTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.makeRounded(radius: 5)
        textView.layer.borderColor = UIColor.wkBlack15.cgColor
        textView.isHidden = true
        textView.contentInset = .init(top: 10, left: 12, bottom: 10, right: 12)
        return textView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.clipsToBounds = false
        return stackView
    }()
    
    private let disposeBag = DisposeBag()
    fileprivate let reasonPublisher = PublishSubject<(String?)>()
    
    init() {
        super.init(frame: .zero)
        
        self.setSelectButton()
        self.setLayout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    private func bind() {
        self.etcReasonTextView.rx.didBeginEditing
            .withUnretained(self)
            .bind { owner, _ in
                owner.etcReasonTextView.layer.borderColor = UIColor.wkMainPurple.cgColor
                owner.etcReasonTextView.layer.borderWidth = 2
            }
            .disposed(by: disposeBag)
        
        self.etcReasonTextView.rx.didEndEditing
            .withUnretained(self)
            .bind { owner, _ in
                owner.etcReasonTextView.layer.borderColor = UIColor.wkBlack15.cgColor
                owner.etcReasonTextView.layer.borderWidth = 1
                owner.reasonPublisher.onNext(owner.etcReasonTextView.text ?? "")
            }
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        self.addSubviews([reasonTitleLabel, stackView])
        self.stackView.addArrangedSubviews([reasonSelectButton, etcReasonTextView])
        
        self.reasonTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.reasonTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        self.reasonSelectButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
        
        self.etcReasonTextView.snp.makeConstraints { make in
            make.height.equalTo(140)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    private func setSelectButton() {
        reasonSelectButton.showsMenuAsPrimaryAction = true
        reasonSelectButton.menu = UIMenu(
            options: .singleSelection,
            children: [UIAction(title: "선택해주세요", state: .on) { [weak self] _ in
                self?.reasonSelectButton.setTitle("    이유 선택", for: .normal)
                self?.reasonSelectButton.setTitleColor(.wkBlack30, for: .normal)
                self?.etcReasonTextView.isHidden = true
                self?.reasonPublisher.onNext(nil)
                self?.endEditing(true)
            }]
            + reasons.map({ [weak self] text in
                UIAction(title: text) { _ in
                    self?.reasonSelectButton.setTitle("    " + text, for: .normal)
                    self?.reasonSelectButton.setTitleColor(.wkBlack, for: .normal)
                    self?.etcReasonTextView.isHidden = true
                    self?.reasonPublisher.onNext(text)
                    self?.endEditing(true)
                }
            })
            + [UIAction(title: "기타", state: .on) { [weak self] _ in
                self?.reasonSelectButton.setTitle("    " + "기타", for: .normal)
                self?.reasonSelectButton.setTitleColor(.wkBlack, for: .normal)
                self?.etcReasonTextView.isHidden = false
            }]
        )
    }
}

extension Reactive where Base: WithdrawalReasonView {
    
    var didSelectReason: Observable<String?> {
        return base.reasonPublisher.asObservable()
    }
}
