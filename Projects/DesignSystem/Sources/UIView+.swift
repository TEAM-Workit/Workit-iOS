//
//  UIView+.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/17.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
