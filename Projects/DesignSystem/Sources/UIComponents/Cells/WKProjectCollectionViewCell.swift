//
//  WKProjectCollectionViewCell.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/11/29.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit

import SnapKit

public final class WKProjectCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        return stackView
    }()
    
    private let projectView = UIView()
    
    private let projectLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.b3M
        label.textColor = UIColor.wkBlack65
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.c2M
        label.textColor = UIColor.wkBlack30
        return label
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.wkBlack8
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.h4B
        label.textColor = UIColor.black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.b2M
        label.textColor = UIColor.wkBlack85
        label.numberOfLines = 2
        return label
    }()
    
    private let tagView = UIView()
    
    private let tagLabel = WKTagLabel()
    
    private let etcLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.c2M
        label.textColor = UIColor.wkBlack30
        return label
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
        self.setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.setBackgroundUI()
        self.setShadowUI()
    }
    
    private func setBackgroundUI() {
        self.backgroundColor = UIColor.white
        self.makeRounded(radius: 5)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.wkBlack4.cgColor
    }
    
    private func setShadowUI() {
        self.layer.shadowColor = UIColor.wkBlack5.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    private func setLayout() {
        self.addSubviews([stackView])
        self.projectView.addSubviews([projectLabel, dateLabel])
        self.tagView.addSubviews([tagLabel, etcLabel])
        
        self.stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
        }

        self.dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.projectLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.dateLabel.snp.leading).inset(-11)
            make.centerY.equalToSuperview()
        }
        
        self.tagLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.etcLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.tagLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
        }
        
        self.projectView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        self.line.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        self.tagView.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    }
    
    private func setStackView() {
        self.stackView.addArrangedSubviews([projectView, line, titleLabel, descriptionLabel, tagView])
        self.stackView.setCustomSpacing(10, after: line)
        self.stackView.setCustomSpacing(4, after: titleLabel)
        self.stackView.setCustomSpacing(16, after: descriptionLabel)
    }
    
    public func setData() {
        // TODO: Project 모델 추가 후 수정 예정
    }
}
