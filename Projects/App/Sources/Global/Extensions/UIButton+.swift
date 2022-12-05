//
//  UIButton+.swift
//  App
//
//  Created by madilyn on 2022/12/05.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIButton

extension UIButton {
    public func setAction(_ closure: @escaping () -> Void) {
        self.addAction( UIAction { _ in closure() }, for: UIControl.Event.touchUpInside)
    }
}
