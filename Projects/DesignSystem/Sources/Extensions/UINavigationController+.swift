//
//  UINavigationController+.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/11/29.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UINavigationController

extension UINavigationController {
    private var backButtonAppearance: UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.clear,
            .font: UIFont.systemFont(ofSize: 0.0)
        ]
        
        return backButtonAppearance
    }
    
    private var backButtonImage: UIImage? {
        return Image.wkArrowBig
            .resize(to: CGSize(width: 24, height: 24))
            .withAlignmentRectInsets(
                UIEdgeInsets(
                    top: 0.0,
                    left: -12.0,
                    bottom: 0.0,
                    right: 0.0
                )
            )
    }
    
    /// navigationBar의 외관을 지정하는 함수입니다.
    /// 색 변경이 필요한 경우 파라미터를 통해 값을 넘겨주고 해당 함수를 호출합니다.
    public func setNavigationBarApperance(
        backgroundColor: UIColor = UIColor.wkWhite,
        tintColor: UIColor = UIColor.wkBlack
    ) {
        let appearance = navigationBarAppearance(
            backgroundColor: backgroundColor,
            titleColor: tintColor
        )
         
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.tintColor = tintColor
    }
    
    private func navigationBarAppearance(
        backgroundColor: UIColor = UIColor.clear,
        titleColor: UIColor = UIColor.wkBlack,
        font: UIFont = UIFont.h3Sb
    ) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: titleColor,
            NSAttributedString.Key.font: font
        ]
        appearance.backgroundColor = backgroundColor
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance

        return appearance
    }
}

