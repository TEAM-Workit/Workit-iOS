//
//  WKPageTab.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/12/05.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit

import SnapKit

// MARK: - Protocols

public protocol PageTabProtocol where Self: UIViewController {
    var pageTitle: String { get }
}

// MARK: - WKPageTab

public final class WKPageTab: UIView {
    
    struct PageContent {
        let button: UIButton
        let viewController: PageTabProtocol
    }
    
    // MARK: - UIComponents
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = UIStackView.Alignment.fill
        stackView.distribution = UIStackView.Distribution.fillEqually
        return stackView
    }()
    
    private lazy var indicatorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.wkBlack8
        return view
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.wkMainPurple
        return view
    }()
    
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private let containerView: UIView = UIView()
    private var parentViewController: UIViewController!
    
    // MARK: - Properties
    
    private var style: Style = Style.`default`
    private var pageContents: [PageContent] = []
    private var currentIndex: Int = 0 {
        didSet {
            updateButtonState()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func selectButton(_ sender: UIButton) {
        guard let index = pageContents.firstIndex(where: { $0.button == sender }),
              index != currentIndex else {
            return
        }
        
        let content = pageContents[index]
        pageViewController.setViewControllers(
            [content.viewController],
            direction: currentIndex < index ? .forward : .reverse,
            animated: true
        ) { [weak self] _ in
            self?.currentIndex = index
        }
        
        self.moveIndicator(to: index)
    }
    
    // MARK: - Methods
    
    public func setup(
        viewControllers: [PageTabProtocol],
        target: UIViewController,
        style: Style = Style.`default`
    ) {
        self.style = style
        self.parentViewController = target
        self.makePageContents(with: viewControllers)
        self.setViewHierarchy()
        self.setConstraints()
        self.setPageViewController()
    }
    
    private func makePageContents(with viewController: [PageTabProtocol]) {
        self.pageContents = viewController.map {
            let button = WKPageButton(
                selectedTitleColor: style.titleSelectedColor,
                defaultTitleColor: style.titleDefaultColor,
                backgroundColor: style.buttonBackgroundColor,
                titleFont: style.titleFont
            )
            button.setTitle($0.pageTitle, for: .normal)
            button.addTarget(self, action: #selector(selectButton(_:)), for: .touchUpInside)
            return PageContent(button: button, viewController: $0)
        }
    }
    
    private func setViewHierarchy() {
        self.parentViewController.addChild(self.pageViewController)
        self.containerView.addSubview(self.pageViewController.view)
        self.addSubviews([self.titleStackView, self.indicatorBackgroundView, self.containerView])
        self.indicatorBackgroundView.addSubview(self.indicatorView)
        self.titleStackView.addArrangedSubviews(self.pageContents.map { $0.button })
    }
    
    private func setConstraints() {
        self.pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(style.buttonHeight)
        }
        
        self.indicatorBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(titleStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(style.indicatorHeight)
        }
        
        self.indicatorView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(pageContents.count)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(indicatorBackgroundView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setPageViewController() {
        self.pageViewController.delegate = self
        self.pageViewController.dataSource = self
        
        for subview in pageViewController.view.subviews {
            if let scrollView = subview as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        if let viewController = self.pageContents.first?.viewController {
            self.pageViewController.setViewControllers(
                [viewController],
                direction: .forward,
                animated: false)
            currentIndex = 0
        }
        
        self.pageViewController.didMove(toParent: self.parentViewController)
    }
    
    private func updateButtonState() {
        self.pageContents.enumerated().forEach { index, content in
            content.button.isSelected = index == currentIndex
        }
    }
    
    private func moveIndicator(to index: Int) {
        self.indicatorView.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset(CGFloat(index) * self.indicatorView.frame.width)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.indicatorBackgroundView.layoutIfNeeded()
        }
    }
}

// MARK: - UIPageViewControllerDataSource

extension WKPageTab: UIPageViewControllerDataSource {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = self.pageContents.firstIndex(where: {
                $0.viewController == viewController
            }) else {
                return nil
            }
            
            let beforeIndex: Int = index - 1
            if beforeIndex >= 0 {
                return self.pageContents[beforeIndex].viewController
            }
            
            return nil
        }
    
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = self.pageContents.firstIndex(where: {
                $0.viewController == viewController
            }) else {
                return nil
            }
            
            let afterIndex: Int = index + 1
            if afterIndex < self.pageContents.count {
                return self.pageContents[afterIndex].viewController
            }
            
            return nil
        }
    
}

// MARK: - UIPageViewControllerDelegate

extension WKPageTab: UIPageViewControllerDelegate {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            guard let viewController = pageViewController.viewControllers?.first,
                  let index = self.pageContents.firstIndex(where: {
                      $0.viewController === viewController
                  }) else {
                return
            }
            
            currentIndex = index
        }
}

// MARK: - UIScrollViewDelegate

extension WKPageTab: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let movedDistance = (scrollView.contentOffset.x - self.pageViewController.view.frame.width) / self.pageViewController.view.frame.width
        self.indicatorView.snp.updateConstraints { make in
            make.leading.equalToSuperview().inset((movedDistance + CGFloat(self.currentIndex)) * self.indicatorView.frame.width)
        }
    }
}

extension WKPageTab {
    public struct Style {
        var indicatorColor: UIColor
        var indicatorBackgroundColor: UIColor
        var indicatorHeight: CGFloat
        
        var buttonBackgroundColor: UIColor
        var buttonHeight: CGFloat
        
        var titleSelectedColor: UIColor
        var titleDefaultColor: UIColor
        var titleFont: UIFont
        
        public static var `default` = Style(
            indicatorColor: UIColor.wkMainPurple,
            indicatorBackgroundColor: UIColor.wkBlack45,
            indicatorHeight: 2.0,
            buttonBackgroundColor: UIColor.wkWhite,
            buttonHeight: 55.0,
            titleSelectedColor: UIColor.wkMainPurple,
            titleDefaultColor: UIColor.wkBlack45,
            titleFont: UIFont.h3Sb
        )
    }
}
