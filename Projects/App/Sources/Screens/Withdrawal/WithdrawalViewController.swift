//
//  WithdrawalViewController.swift
//  App
//
//  Created by 김혜수 on 2023/04/12.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import ReactorKit
import RxSwift
import SnapKit

import Mixpanel

// swiftlint:disable all
final class WithdrawalViewController: BaseViewController, View {
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    typealias Reactor = WithdrawalReactor
    
    enum Text {
        static let navigationTitle: String = "회원탈퇴"
        static let withdrawTitle: String = "정말 떠나시는 건가요?"
        static let description: String = "지금 워킷을 떠나시면 워킷의 모든 기록들이 사라지게 돼요. 이전에 기록한 역량, 프로젝트별 기록은 더 이상 확인하실 수 없어요."
    }
    
    enum AlertType {
        case requestWithdraw
        case completeWithdraw
        
        var title: String? {
            return nil
        }
        
        var message: String? {
            switch self {
            case .requestWithdraw:
                return "정말 탈퇴하시겠습니까?"
            case .completeWithdraw:
                return "탈퇴 완료 되었습니다."
            }
        }
        
        var okButton: (title: String, style: UIAlertAction.Style) {
            switch self {
            case .requestWithdraw:
                return ("탈퇴하기", .destructive)
            case .completeWithdraw:
                return ("확인", .default)
            }
        }
        
        var cancelButton: (title: String, style: UIAlertAction.Style)? {
            switch self {
            case .requestWithdraw:
                return ("취소", .cancel)
            case .completeWithdraw:
                return nil
            }
        }
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
        label.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        label.textColor = .wkBlack85
        label.setLineSpacing(lineSpacing: 5)
        label.numberOfLines = 0
        return label
    }()
    
    private let withDrawalReasonView = WithdrawalReasonView()
    private let withDrawalBottomView = WithdrawalBottomView()
    
    private let withDrawPublisher = PublishSubject<()>()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.addKeyboardObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nibName
        )
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nibName
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.scrollView.contentOffset.y = 200
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.withDrawalBottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: NSNotification) {
        self.scrollView.contentOffset.y = 0
        self.withDrawalBottomView.transform = .identity
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
        
        self.scrollContentsView.rx.tapGesture
            .withUnretained(self)
            .bind { owner, _ in
                owner.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        self.withDrawalBottomView.rx.withdrawButtonDidTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.presentAlert(
                    type: .requestWithdraw,
                    okAction: { _ in
                        owner.presentAlert(
                            type: .completeWithdraw,
                            okAction: { _ in
                                Mixpanel.mainInstance().track(event: "설정_탈퇴 모달 확인 버튼_Clicked")
                                owner.withDrawPublisher.onNext(())
                            }
                        )
                    })
            }
            .disposed(by: disposeBag)
        
        self.withDrawPublisher
            .map { _ in Reactor.Action.withdrawButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.withDrawalReasonView.rx.didSelectReason
            .map { Reactor.Action.selectReason($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.withDrawalReasonView.rx.etcReasonText
            .map { Reactor.Action.etcReasonTextViewDidChange($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.closeButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }
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
        
        reactor.state
            .map { $0.isCompletedWithDraw }
            .distinctUntilChanged()
            .filter { $0 }
            .bind { _ in
                UserDefaultsManager.shared.removeToken()
                RootViewChange.shared.setRootViewController(.splash)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnableClickWithdrawButton }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isEnable in
                owner.withDrawalBottomView.setWithdrawButtonState(isEnabled: isEnable)
            }
            .disposed(by: disposeBag)
    }
    
    override func setLayout() {
        self.view.addSubviews([navigationView, scrollContainerView, withDrawalBottomView])
        self.scrollContainerView.addSubviews([scrollView])
        self.scrollView.addSubviews([scrollContentsView])
        self.navigationView.addSubviews([navigationTitleLabel, closeButton])
        self.scrollContentsView.addSubviews([titleLabel, descriptionLabel, withDrawalReasonView])
        
        self.navigationView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(56)
        }
        
        self.scrollContainerView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.withDrawalBottomView.snp.top)
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
            make.height.equalTo(26)
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
    
    func presentAlert(type: AlertType, okAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(
            title: type.title,
            message: type.message,
            preferredStyle: .alert)
        
        if let cancel = type.cancelButton {
            let cancelAlert = UIAlertAction(title: cancel.title, style: cancel.style)
            alert.addAction(cancelAlert)
        }
        
        let okAlert = UIAlertAction(title: type.okButton.title, style: type.okButton.style, handler: okAction)
        alert.addAction(okAlert)
        
        self.present(alert, animated: true)
    }
}
// swiftlint:enable all
