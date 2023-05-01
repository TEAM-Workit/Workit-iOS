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
    
    public lazy var wkTabbar = WKTabbar()
    
    open override func viewDidLoad() {
        self.setLayout()
        self.setTabbar()
    }
    
    private func setLayout() {
        self.tabBar.isHidden = true
        self.view.addSubview(wkTabbar)
        
        wkTabbar.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        wkTabbar.setItems(
            [WKTabbarItem(
                title: "홈",
                selectedImage: Image.wkHomeTab,
                deselectedImage: Image.wkHomeTabUnselected,
                selectedColor: .wkMainNavy,
                deselectedColor: .wkBlack30),
             WKTabbarItem(
                title: "모아보기",
                selectedImage: Image.wkLibraryTab,
                deselectedImage: Image.wkLibraryTabUnselected,
                selectedColor: .wkMainNavy,
                deselectedColor: .wkBlack30)
            ]
        )
    }
    
    private func setTabbar() {
        self.wkTabbar.delegate = self
    }
}

extension WKTabbarController: WKTabbarDelegate {
    func wkTabbar(_ tabbar: WKTabbar, didSelectedItemAt index: Int) {
        self.selectedIndex = index
    }
}


