//
//  SceneDelegate.swift
//  App
//
//  Created by 김혜수 on 2022/11/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import UIKit
import Global

import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
      //  UserDefaultsManager.shared.accessToken = nil
        
        if UserDefaultsManager.shared.accessToken == nil {
            RootViewChange.shared.setRootViewController(.onboarding)
            window?.makeKeyAndVisible()
            return
        }
        
        RootViewChange.shared.setRootViewController(.login)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
    
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}
