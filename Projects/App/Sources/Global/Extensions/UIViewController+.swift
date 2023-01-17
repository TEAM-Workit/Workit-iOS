//
//  UIViewController+.swift
//  App
//
//  Created by 김혜수 on 2022/11/09.
//  Copyright © 2022 com.workit. All rights reserved.
//
//  This source is from https://github.com/devxoul/RxViewController/blob/master/Sources/RxViewController/UIViewController%2BRx.swift
// Copyright © devxoul

#if os(iOS) || os(tvOS)
import UIKit
import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var viewDidAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var viewWillDisappear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var viewDidDisappear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewDidDisappear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }

    var willMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = methodInvoked(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    var didMoveToParentViewController: ControlEvent<UIViewController?> {
        let source = methodInvoked(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }

    var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }

    var isVisible: Observable<Bool> {
        let viewDidAppearObservable = base.rx.viewDidAppear.map { _ in true }
        let viewWillDisappearObservable = base.rx.viewWillDisappear.map { _ in false }
        return Observable<Bool>.merge(viewDidAppearObservable, viewWillDisappearObservable)
    }

    var isDismissing: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false }
                return base.isBeingDismissed
            }
    }

    var isPopping: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false }
                return base.isMovingFromParent
            }
    }

    var isDismissingWithNavigationController: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false }
                guard let navigationController = base.navigationController else { return false }
                return navigationController.isBeingDismissed
            }
    }

    var isPoppingWithNavigationController: Observable<Void> {
        return base.rx
            .methodInvoked(#selector(Base.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak base] in
                guard let base = base else { return false }
                guard let navigationController = base.navigationController else { return false }
                return navigationController.isMovingFromParent
            }
    }
}
#endif

