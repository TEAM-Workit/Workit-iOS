//
//  UIStackView+.swift
//  Global
//
//  Created by 김혜수 on 2022/12/06.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIStackView

extension UIStackView {
    public func addArragnedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}
