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

import SnapKit

final class SplashViewController: UIViewController {
    
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
        setTimer()
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
}
