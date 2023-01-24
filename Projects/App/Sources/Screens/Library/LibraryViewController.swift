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
    
    private let viewControllers: [PageTabProtocol] = [AbilityViewController(), ProjectViewController()]
    private let pageTab = WKPageTab()
    
    override func viewDidLoad() {
        setPageTab()
        setLayout()
    }
    
    func setPageTab() {
        pageTab.setup(viewControllers: viewControllers, target: self)
    }
    
    override func setLayout() {
        self.view.addSubview(pageTab)
        
        self.pageTab.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
}
