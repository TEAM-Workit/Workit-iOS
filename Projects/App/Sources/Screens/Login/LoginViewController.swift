//
//  LoginViewController.swift
//  App
//
//  Created by 김혜수 on 2022/12/09.
//  Copyright © 2022 com.workit. All rights reserved.
//

import AuthenticationServices
import DesignSystem
import Domain
import Global
import UIKit

import RxKakaoSDKUser
import KakaoSDKUser
import ReactorKit
import RxSwift
import SnapKit
import SafariServices

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
        label.setUnderLineAttributes(lineTexts: [Text.termOfService, Text.privacyPolicy])
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
        
        self.addTapGesture()
    }
    
    private func bindAction() {
        kakaoLoginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.kakaoLogin()
            }
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.appleLogin()
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods
    
    private func addTapGesture() {
        let taps = UITapGestureRecognizer(target: self, action: #selector(didTapHyperlink(_:)))
        agreeLabel.isUserInteractionEnabled = true
        agreeLabel.addGestureRecognizer(taps)
    }
    
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
                    RootViewChange.shared.setRootViewController(.home)
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
                    RootViewChange.shared.setRootViewController(.home)
                })
                .disposed(by: disposeBag)
        }
    }
    
    @objc
    private func didTapHyperlink(_ sender: UITapGestureRecognizer) {
        guard let content = agreeLabel.text else { return }
        
        let termsURL = [
            "https://www.notion.so/c422fef3eb30451cab9e6d6aa7b98024",
            "https://www.notion.so/5ddeafa7cd2c4c378cdf23a34aec316b"
        ]
        
        let ranges: [NSRange] = [
            (content as NSString).range(of: Text.termOfService),
            (content as NSString).range(of: Text.privacyPolicy)
        ]
        
        let tapLocation = sender.location(in: agreeLabel)
        let index = agreeLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        for range in ranges where range.checkTargetWordSelectedRange(contain: index) {
            guard let target = ranges.firstIndex(of: range) else { return }
            let scheme = termsURL[target]
            guard
                let encodingScheme = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
            else { return }
            
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    
    private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            #if DEBUG
            print("token", String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? "")
            print("username", appleIDCredential.fullName?.formatted() ?? "")
            #endif
            
            let token = String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? ""
            let request = PostSocialLoginRequestValue(
                socialType: .APPLE,
                socialId: token,
                nickName: appleIDCredential.fullName?.formatted() ?? ""
            )
            
            self.authUseCase.postSocialLogin(requestValue: request)
                .bind { authToken in
                    UserDefaultsManager.shared.accessToken = authToken.accessToken
                    RootViewChange.shared.setRootViewController(.home)
                }
                .disposed(by: disposeBag)
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("연동 실패")
    }
}
