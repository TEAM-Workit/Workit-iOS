//
//  HomeDescriptionView.swift
//  App
//
//  Created by 김혜수 on 2022/12/30.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

final class HomeBannerView: UIView {

    enum Text {
        static let nameSuffix = "님,"
        static let title = "매일의 기록을 모아\n커리어를 완성해보세요"
        static let description = "오늘의 업무 기록을 적어주세요."
    }

    // MARK: - UIComponenets

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .h3B
        label.textColor = .white
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h3M
        label.textColor = .wkSubPurple15
        label.text = Text.title
        label.numberOfLines = 2
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .b2M
        label.textColor = .wkSubPurple45
        label.text = Text.description
        return label
    }()

    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.wkBanner1
        return imageView
    }()

    // MARK: - Initializer

    public init() {
        super.init(frame: .zero)

        setLayout()
        setName(name: "워킷")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setLayout() {
        self.addSubviews([nameLabel, titleLabel, descriptionLabel, mainImageView])

        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(29)
            make.leading.equalToSuperview()
        }

        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview()
        }

        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }

        self.mainImageView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.equalTo(182)
            make.height.equalTo(214)
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(214)
        }
    }

    internal func setName(name: String) {
        self.nameLabel.text = name + Text.nameSuffix
    }
}
