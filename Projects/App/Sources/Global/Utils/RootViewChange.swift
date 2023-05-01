//
//  RootViewChange.swift
//  App
//
//  Created by 김혜수 on 2023/04/30.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Data
import Domain
import UIKit

final class RootViewChange {
    
    static let shared = RootViewChange()
    
    enum ViewControllerType {
        case home
        case login
        case onboarding
        case splash
    }
    
    private init() {}
    
    func setRootViewController(_ newRoot: ViewControllerType) {
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        guard let delegate = sceneDelegate else {
            return
        }
        
        switch newRoot {
        case .home:
            let mainTabController = MainTabbarController()
            delegate.window?.rootViewController = mainTabController
            
        case .login:
            let loginViewController = LoginViewController(
                authUseCase: DefaultAuthUseCase(authRepository: DefaultAuthRepository()))
            delegate.window?.rootViewController = loginViewController
            
        case .onboarding:
            let onboardingViewController = OnboardingViewController()
            onboardingViewController.reactor = OnboardingReactor()
            delegate.window?.rootViewController = onboardingViewController
            
        case .splash:
            let splashViewController = SplashViewController()
            delegate.window?.rootViewController = splashViewController
        }
    }
}
