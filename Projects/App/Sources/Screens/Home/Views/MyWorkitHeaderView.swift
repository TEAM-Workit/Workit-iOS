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
        static let myWorkit = "마이 워킷"
    }

    private let myWorkitLabel: UILabel = {
        let label = UILabel()
        label.text = Text.myWorkit
        label.font = .h3B
        label.textColor = .wkBlack
        return label
    }()

    private let dateButton = WKDateButton(fromDate: Date())

    override init(frame: CGRect) {
        super.init(frame: frame)

        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setLayout() {
        self.addSubviews([myWorkitLabel, dateButton])

        myWorkitLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.equalToSuperview().inset(20)
        }

        dateButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(28)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
