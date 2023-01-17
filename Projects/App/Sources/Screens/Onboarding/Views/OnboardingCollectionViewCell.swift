//
//  OnboardingCollectionViewCell.swift
//  App
//
//  Created by 김혜수 on 2023/01/17.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponenets

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .wkBlack
        label.font = .h1B
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .wkBlack45
        label.font = .b2M
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setStackView()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func setStackView() {
        self.stackView.addArrangedSubviews([titleLabel, subtitleLabel, imageView])
        self.stackView.setCustomSpacing(12, after: titleLabel)
        self.stackView.setCustomSpacing(29, after: subtitleLabel)
    }

    private func setLayout() {
        self.addSubviews([stackView])

        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(57)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(29)
        }
    
        self.subtitleLabel.snp.makeConstraints { make in
            make.height.equalTo(38)
        }
    }
    
    internal func setData(onboarding: Onboarding) {
        self.titleLabel.text = onboarding.title
        self.subtitleLabel.text = onboarding.subtitle
        self.imageView.image = onboarding.image
    }
}
