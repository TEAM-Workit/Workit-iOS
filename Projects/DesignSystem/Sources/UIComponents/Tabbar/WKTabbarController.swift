//
//  WKTabbarController.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/12/12.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import SnapKit

open class WKTabbarController: UITabBarController {

    // MARK: - UIComponents
    
    private let wkTabbar = WKTabbar()
    
    open override func viewDidLoad() {
        self.setLayout()
    }
    
    private func setLayout() {
        self.tabBar.isHidden = true
        self.view.addSubview(wkTabbar)
       
        wkTabbar.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        wkTabbar.setItems([WKTabbarItem(selectedImage: Image.wkHomeTab,
                                        deselectedImage: Image.wkHomeTab,
                                        selectedColor: .wkMainNavy,
                                        deselectedColor: .wkBlack30)])
    }
    

}


