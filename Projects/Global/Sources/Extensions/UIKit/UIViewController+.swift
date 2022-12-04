//
//  UIViewController+.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/19.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
    /// 화면 터치시 작성 종료하는 메서드
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
