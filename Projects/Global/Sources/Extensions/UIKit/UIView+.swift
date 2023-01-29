//
//  UIView+.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/17.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIView

extension UIView {
    public func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    public func makeRounded(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    public func setGradient(firstColor: UIColor, secondColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
