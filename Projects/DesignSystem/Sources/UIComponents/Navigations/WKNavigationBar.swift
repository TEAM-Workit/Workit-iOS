//
//  WKNavigationBar.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/11/29.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UINavigationBar

/// NavigationController의 NavigationBar를 사용할 수 없을 때 (Modal Present 등)
/// 단독으로 사용할 수 있는 NavigationBar입니다.
public class WKNavigationBar: UINavigationBar {

    public init() {
        super.init(frame: .zero)
        
        setStyle()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.pushItem(UINavigationItem(), animated: true)
        self.shadowImage = UIImage()
        self.isTranslucent = false
        self.barTintColor = UIColor.wkWhite
        self.tintColor = UIColor.wkBlack
    }
 
}
