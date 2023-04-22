//
//  WithdrawalViewController.swift
//  App
//
//  Created by 김혜수 on 2023/04/12.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import ReactorKit
import SnapKit

final class WithdrawalViewController: BaseViewController, View {
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    typealias Reactor = WithdrawalReactor
    
    enum Text {
        static let navigationTitle: String = "회원탈퇴"
        static let withdrawTitle: String = "정말 떠나시는 건가요?"
        static let description: String = "지금 워킷을 떠나시면 워킷의 모든 기록들이 사라지게 돼요. 이전에 기록한 역량, 프로젝트별 기록은 더 이상 확인하실 수 없어요."
      
    }
    
    private let navigationView = UIView()
    private let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Text.navigationTitle
        label.font = .h3Sb
        label.textColor = .black
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.wkX, for: .normal)
        return button
    }()
    
    private let scrollContainerView = UIView()
    private let scrollView = UIScrollView()
    private let scrollContentsView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Text.withdrawTitle
        label.font = .h2B
        label.textColor = .wkBlack
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = Text.description
        label.font = DesignSystemFontFamily.Suit.medium.font(size: 15)
        label.textColor = .wkBlack85
        label.numberOfLines = 0
        return label
    }()
    
    private let withDrawalReasonView = WithdrawalReasonView()
    private let withDrawalBottomView = WithdrawalBottomView()
   
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    func bind(reactor: WithdrawalReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: WithdrawalReactor) {
        self.withDrawalBottomView.rx.agreeButtonDidTap
            .map { _ in Reactor.Action.agreeButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: WithdrawalReactor) {
        reactor.state
            .map { $0.agreeButtonSelected }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isSelected in
                owner.withDrawalBottomView.changeAgreeButtonState(isSelected: isSelected)
            }
            .disposed(by: disposeBag)
    }
    
    override func setLayout() {
        self.view.addSubviews([navigationView, scrollContainerView])
        self.scrollContainerView.addSubviews([scrollView])
        self.scrollView.addSubviews([scrollContentsView])
        self.navigationView.addSubviews([navigationTitleLabel, closeButton])
        self.scrollContentsView.addSubviews([titleLabel, descriptionLabel, withDrawalReasonView, withDrawalBottomView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        self.scrollContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        self.scrollContentsView.snp.makeConstraints { make in
            make.width.equalTo(self.scrollContainerView.snp.width)
            make.height.equalTo(self.scrollContainerView.snp.height).priority(.low)
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        self.navigationTitleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
            make.centerY.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.withDrawalReasonView.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.withDrawalBottomView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(88)
        }
    }
}
