//
//  MainTabbarController.swift
//  App
//
//  Created by yejiyun-MN on 2023/05/01.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Data
import DesignSystem
import UIKit

class MainTabbarController: WKTabbarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTabbar()
        self.setMiddleButtonAction()
    }
    
    private func setTabbar() {
        let homeNavigationController = WKNavigationConroller(rootViewController: makeHomeViewController())
        let libraryViewController = WKNavigationConroller(rootViewController: LibraryViewController())
        
        self.setViewControllers([homeNavigationController, libraryViewController], animated: true)
    }
    
    private func makeHomeViewController() -> HomeViewController {
        let homeViewController = HomeViewController()
        homeViewController.reactor = HomeReactor(
            workUseCase: DefaultWorkUseCase(workRepository: DefaultWorkRepository()),
            userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository())
        )
        return homeViewController
    }
    
    private func setMiddleButtonAction() {
        self.wkTabbar.centerButtonActionHandler = {   
            let writeViewController = WriteViewController()
            writeViewController.modalPresentationStyle = .fullScreen
            self.present(writeViewController, animated: true)
        }
    }
}
