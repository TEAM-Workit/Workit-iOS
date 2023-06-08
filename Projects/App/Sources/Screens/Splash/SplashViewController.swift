//
//  SplashViewController.swift
//  App
//
//  Created by 김혜수 on 2023/04/30.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import RxSwift
import SnapKit

final class SplashViewController: UIViewController {
    
    struct Config {
        static let appId = "6448702578"
    }
    
    private let disposeBag = DisposeBag()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.imgSplashLogo
        return imageView
    }()
    
    private let textLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.imgSplashTextLogo
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setLayout()
        checkMinimumVersion()
    }
    
    private func setUI() {
        self.view.backgroundColor = .wkMainPurple
    }
    
    private func setLayout() {
        self.view.addSubviews([logoImageView, textLogoImageView])
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-47)
            make.width.equalTo(151)
            make.height.equalTo(94)
        }
        
        self.textLogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.width.equalTo(98)
            make.height.equalTo(40)
        }
    }
    
    private func setTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if UserDefaultsManager.shared.accessToken == nil {
                RootViewChange.shared.setRootViewController(.onboarding)
                return
            }
            RootViewChange.shared.setRootViewController(.home)
        }
    }
    
    private func checkMinimumVersion() {
        // 지원 버전 체크
        let shouldUpdateApplication = FirebaseService.shared.stateValuePublisher
            .map { state -> Bool in
                print("✅ state", state)
                
                guard
                    let minimumVersion = state.minimumVersion
                else {
                    return false
                }
                
                print(minimumVersion)
                let current = Bundle.appVersion.components(separatedBy: ".").map({ Int($0)! })
                let minimum = minimumVersion.components(separatedBy: ".").map({ Int($0)! })
                
                print(current, minimum)
                return current.lexicographicallyPrecedes(minimum)
            }
            .share()
        
        /// 지원 버전보다 낮을 경우 앱스토어로 이동
        shouldUpdateApplication
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.openAppstore()
                return
            })
            .disposed(by: disposeBag)
        
        shouldUpdateApplication
            .filter { !$0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.setTimer()
            })
            .disposed(by: disposeBag)
    }
    
    private func openAppstore() {
        guard
            let url = URL(string: "itms-apps://itunes.apple.com/app/\(Config.appId)")
        else {
            return
        }
        
        self.showCustomAlert(
            title: "업데이트 알림",
            message:
            """
Workit의 새로운 버전 업데이트가 있습니다.
버전 업데이트를 통해 새 기능을 만나보세요!
""",
            buttons: [
                AlertButton(title: "업데이트", style: .default, action: { _ in
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
                
            ])
    }
    
}

extension Bundle {
    static var appVersion: String {
        guard
            let version = self.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        else {
            return ""
        }
        return version
    }
}
