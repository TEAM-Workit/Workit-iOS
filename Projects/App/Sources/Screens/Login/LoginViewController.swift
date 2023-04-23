//
//  LoginViewController.swift
//  App
//
//  Created by 김혜수 on 2022/12/09.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import Domain
import Global
import UIKit

import RxKakaoSDKUser
import KakaoSDKUser
import ReactorKit
import RxSwift
import SnapKit

final class LoginViewController: BaseViewController {
    
    private let authUseCase: AuthUseCase

    enum Number {
        static let deviceHeight: CGFloat = UIScreen.main.bounds.height
    }

    enum Text {
        static let workitDescription = "사회초년생을 위한 커리어 기록"
        static let agreeMessage = "로그인 시 이용약관과 개인정보 처리 방침에 동의하게 됩니다."
        static let termOfService = "이용약관"
        static let privacyPolicy = "개인정보 처리 방침"
    }

    // MARK: - UIComponenets

    private let workitLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.imgWorkitTextLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let workitLabel: UILabel = {
        let label = UILabel()
        label.text = Text.workitDescription
        label.textColor = .wkBlack85
        label.font = .b1Sb
        return label
    }()

    private let kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.btnLoginKakao, for: .normal)
        return button
    }()

    private let appleLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.btnLoginApple, for: .normal)
        return button
    }()

    private let agreeLabel: UILabel = {
        let label = UILabel()
        label.text = Text.agreeMessage
        label.font = .b3R
        label.textAlignment = .center
        label.textColor = .wkBlack65
        label.changeFont(targetStrings: [Text.termOfService, Text.privacyPolicy], font: .b3Sb)
        return label
    }()

    private let logoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let loginButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(authUseCase: AuthUseCase) {
        self.authUseCase = authUseCase
        super.init(nibName: nil, bundle: nil)

        self.setLayout()
        self.setStackView()
        self.bindAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func bindAction() {
        kakaoLoginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.kakaoLogin()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
    
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            /// 카카오톡으로 로그인
            UserApi.shared.rx.loginWithKakaoTalk()
                .withUnretained(self)
                .flatMap { owner, oauthToken in
                    owner.authUseCase.postSocialLogin(requestValue: PostSocialLoginRequestValue(
                        socialType: .KAKAO,
                        socialId: oauthToken.accessToken))
                }
                .bind(onNext: { authToken in
                    UserDefaultsManager.shared.accessToken = authToken.accessToken
                })
                .disposed(by: disposeBag)
        } else {
            /// 카카오 계정으로 로그인 (카카오톡 없는 경우)
            UserApi.shared.rx.loginWithKakaoAccount()
                .withUnretained(self)
                .flatMap { owner, oauthToken in
                    owner.authUseCase.postSocialLogin(requestValue: PostSocialLoginRequestValue(
                        socialType: .KAKAO,
                        socialId: oauthToken.accessToken))
                }
                .bind(onNext: { authToken in
                    UserDefaultsManager.shared.accessToken = authToken.accessToken
                })
                .disposed(by: disposeBag)
        }
    }

    override func setLayout() {
        self.view.addSubviews([self.logoStackView, self.loginButtonStackView])

        self.logoStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-52/812 * Number.deviceHeight)
        }

        self.loginButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(46)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        self.workitLogoImageView.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(67)
        }

        self.workitLabel.snp.makeConstraints { make in
            make.height.equalTo(17)
        }

        self.kakaoLoginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        self.appleLoginButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    private func setStackView() {
        self.logoStackView.addArrangedSubviews([workitLogoImageView, workitLabel])
        self.loginButtonStackView.addArrangedSubviews([kakaoLoginButton, appleLoginButton, agreeLabel])
        self.loginButtonStackView.setCustomSpacing(8, after: kakaoLoginButton)
        self.loginButtonStackView.setCustomSpacing(25, after: appleLoginButton)
    }
}
