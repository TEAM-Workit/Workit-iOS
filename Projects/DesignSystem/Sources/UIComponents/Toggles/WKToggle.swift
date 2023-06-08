//
//  WKToggle.swift
//  App
//
//  Created by 윤예지 on 2022/11/19.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import SnapKit

// MARK: - Protocols

public protocol WKToggleDelegate: AnyObject {
    func toggleStateChanged(_ toggle: WKToggle, isOn: Bool)
}

public class WKToggle: UIView {

    enum Number {
        static let circleInnerPadding: CGFloat = 2
        static let circleWidthHeight: CGFloat = 24
        static let containerWidth: CGFloat = 49
        static let containerHeight: CGFloat = 28
        static let duration: CGFloat = 0.2
    }

    // MARK: - UIComponents

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkMainPurple
        return view
    }()

    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // MARK: - Properties

    public var isOn: Bool = true {
        didSet {
            isOn ? turnOn() : turnOff()
        }
    }
    public weak var delegate: WKToggleDelegate?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setViewHierarchy()
        setDefaultConstraints()
        setLayout()
        makeViewRounded()
        setClickEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions

    @objc
    private func toggleDidTap(sender: UITapGestureRecognizer) {
        self.isOn.toggle()
        if self.isOn {
            self.turnOn()
        } else {
            self.turnOff()
        }
        self.delegate?.toggleStateChanged(self, isOn: self.isOn)
    }

    // MARK: - Methods

    private func setViewHierarchy() {
        self.addSubview(containerView)
        self.containerView.addSubview(circleView)
    }

    private func setDefaultConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(Number.containerWidth)
            make.height.equalTo(Number.containerHeight)
        }
    }

    private func setLayout() {
        self.containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.circleView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Number.circleInnerPadding)
            make.width.height.equalTo(Number.circleWidthHeight)
        }
    }

    private func makeViewRounded() {
        self.makeRounded(radius: Number.containerHeight / 2)
        self.circleView.makeRounded(radius: Number.circleWidthHeight / 2)
    }

    private func setClickEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleDidTap(sender:)))
        self.addGestureRecognizer(tapGesture)
    }

    private func turnOn() {
        self.circleView.snp.remakeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(Number.circleInnerPadding)
            make.width.height.equalTo(Number.circleWidthHeight)
        }

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
            self.containerView.backgroundColor = .wkMainPurple
        }
    }

    private func turnOff() {
        self.circleView.snp.remakeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(Number.circleInnerPadding)
            make.width.height.equalTo(Number.circleWidthHeight)
        }

        UIView.animate(withDuration: Number.duration) {
            self.layoutIfNeeded()
            self.containerView.backgroundColor = .gray
        }
    }

}
