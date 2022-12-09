//
//  UIButton+.swift
//  DesignSystem
//
//  Created by madilyn on 2022/12/06.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIButton

extension UIButton {
    public func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let minimumSize: CGSize = CGSize(width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(minimumSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(origin: CGPoint.zero, size: minimumSize))
        }
        
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        
        self.clipsToBounds = true
        self.setBackgroundImage(colorImage, for: state)
    }
}
