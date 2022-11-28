//
//  UIView+Reactive.swift
//  Global
//
//  Created by 김혜수 on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UIView

import RxGesture
import RxSwift

public extension Reactive where Base: UIView {
    var tapGesture: Observable<Void> {
        return tapGesture { _, delegate in
            delegate.simultaneousRecognitionPolicy = .never
        }
        .when(.recognized)
        .map { _ in }
    }
}
