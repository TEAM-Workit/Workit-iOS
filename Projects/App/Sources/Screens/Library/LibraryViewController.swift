//
//  LibraryViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Data
import Domain
import DesignSystem
import UIKit

import ReactorKit

final class LibraryViewController: BaseViewController {
    
    // MARK: - UIComponenets
    
    private lazy var abilityViewController = AbilityViewController()
    private lazy var projectViewController = ProjectViewController()
    private lazy var viewControllers: [PageTabProtocol] = [abilityViewController, projectViewController]
    private let pageTab = WKPageTab()
    
    // MARK: - Properties
    
    private let usecase = DefaultCollectionUseCase(collectionRepository: DefaultCollectionRepository())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        self.setReactor()
        self.setPageTab()
        self.setLayout()
    }
    
    // MARK: - Methods
    
    func setPageTab() {
        self.pageTab.setup(viewControllers: viewControllers, target: self)
    }
    
    override func setLayout() {
        self.view.addSubview(pageTab)
        
        self.pageTab.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    func setReactor() {
        self.abilityViewController.reactor = AbilityReactor(libraryUseCase: usecase)
        self.projectViewController.reactor = ProjectReactor(libraryUseCase: usecase)
    }
    
}
