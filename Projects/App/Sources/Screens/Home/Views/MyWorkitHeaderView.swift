//
//  MyWorkitHeaderView.swift
//  App
//
//  Created by 김혜수 on 2022/12/22.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

final class MyWorkitHeaderView: UICollectionReusableView {

    enum Text {
        static let myWorkit: String = "마이 워킷"
    }

    // MARK: - UIComponenets

    private let backgroundRadiusView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkWhite
        view.makeRounded(radius: 20)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private let myWorkitLabel: UILabel = {
        let label = UILabel()
        label.text = Text.myWorkit
        label.font = .h3B
        label.textColor = .wkBlack
        return label
    }()

    private let dateButton = WKDateButton(fromDate: Date())

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        setBackgroundColor()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setBackgroundColor() {
        self.backgroundColor = .wkMainPurple
    }

    private func setLayout() {
        self.addSubviews([backgroundRadiusView])
        self.backgroundRadiusView.addSubviews([myWorkitLabel, dateButton])

        self.backgroundRadiusView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.myWorkitLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(20)
        }

        self.dateButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
