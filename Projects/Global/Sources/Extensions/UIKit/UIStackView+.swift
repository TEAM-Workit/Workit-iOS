//
//  UIStackView+.swift
//  Global
//
//  Created by 윤예지 on 2022/12/06.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIStackView

extension UIStackView {
    public func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
