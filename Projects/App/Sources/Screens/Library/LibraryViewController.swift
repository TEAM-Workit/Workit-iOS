//
//  LibraryViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

final class LibraryViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewControllers: [PageTabProtocol] = [AbilityViewController(), ProjectViewController()]
    
    // MARK: - UIComponenets
    
    private let pageTab = WKPageTab()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
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
    
}
