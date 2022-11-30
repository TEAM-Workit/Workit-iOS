//
//  WKNavigationController.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/11/27.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit.UINavigationBar

public final class WKNavigationConroller: UINavigationController {
        
    // MARK: - Properties
    
    private lazy var fullAreaBackGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: - LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarApperance()
        self.setFullAreaBackGesture()
    }
    
}

// MARK: - UIGestrueRecognizerDelegate

extension WKNavigationConroller: UIGestureRecognizerDelegate {
    /// 화면의 모든 지점에서 BackGesture가 가능하도록 설정합니다.
    private func setFullAreaBackGesture() {
        guard
            let interactivePopGestureRecognizer = interactivePopGestureRecognizer,
            let targets = interactivePopGestureRecognizer.value(forKey: "targets")
        else {
            return
        }
        
        fullAreaBackGestureRecognizer.setValue(targets, forKey: "targets")
        fullAreaBackGestureRecognizer.delegate = self
        view.addGestureRecognizer(fullAreaBackGestureRecognizer)
    }
    
    /// navigationController의 stack이 1보다 크면서 기본 swipeGesture가 true 상태일 경우 full back gesture가 가능하도록 합니다.
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isSystemSwipeBackEnabled = interactivePopGestureRecognizer?.isEnabled == true
        let isNotRootViewController = viewControllers.count > 1
        return isSystemSwipeBackEnabled && isNotRootViewController
    }
}
