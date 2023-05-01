//
//  WKPageControl.swift
//  App
//
//  Created by 김혜수 on 2023/01/21.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

final class OnboardingPageControl: UIView {
    
    // MARK: - UIComponenets
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.makeRounded(radius: 5)
        view.backgroundColor = .wkBlack15
        return view
    }()
    
    private let dot2View: UIView = {
        let view = UIView()
        view.makeRounded(radius: 5)
        view.backgroundColor = .wkBlack15
        return view
    }()
    
    private let longDotView: UIView = {
        let view = UIView()
        view.makeRounded(radius: 5)
        view.backgroundColor = .wkMainPurple
        return view
    }()
    
    // MARK: - Initializer
    
    init() {
        super.init(frame: .zero)
        
        self.setLayout()
        self.setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubviews([stackView])
        
        self.stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        self.longDotView.snp.makeConstraints { make in
            make.width.equalTo(29)
        }
        
        self.dotView.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
        
        self.dot2View.snp.makeConstraints { make in
            make.width.equalTo(10)
        }
    }
    
    private func setStackView() {
        self.stackView.addArrangedSubviews([longDotView, dotView, dot2View])
    }
    
    internal func setPage(page: Int) {
        self.stackView.removeArrangedSubview(longDotView)
        self.stackView.insertArrangedSubview(longDotView, at: page)
    }
}
