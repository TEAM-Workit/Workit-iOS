//
//  SelectAbilityTableViewCell.swift
//  DesignSystem
//
//  Created by madilyn on 2023/01/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import DesignSystem
import Global
import UIKit

import SnapKit

final class SelectAbilityTableViewCell: UITableViewCell {
    
    // MARK: UIComponents
    
    private let titleView: UIView = {
        let view: UIView = UIView()
        view.makeRounded(radius: 6)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.wkBlack15.cgColor
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = UIImageView()
        imageView.image = Image.wkSkillChoosePlus
        imageView.tintColor = .wkMainNavy
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .b1Sb
        return label
    }()
    
    // MARK: Properties
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setSelectedUI()
            } else {
                self.setDeselectedUI()
            }
        }
    }
    
    private var isHardAbility: Bool = true
    
    private lazy var abilityBackgroundColor: UIColor = {
        return isHardAbility ? .wkSubNavy20 : .wkSubPurple15
    }()
    
    private lazy var abilityTintColor: UIColor = {
        return isHardAbility ? .wkMainNavy : .wkMainPurple
    }()
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setLayout()
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setData(data: Ability, isHard: Bool) {
        self.isHardAbility = isHard
        self.titleLabel.text = data.name
        self.titleLabel.sizeToFit()
    }
}

// MARK: - UI

extension SelectAbilityTableViewCell {
    
    private func setDeselectedUI() {
        self.titleView.layer.borderColor = UIColor.wkBlack15.cgColor
        self.titleView.backgroundColor = .white
        self.iconImageView.tintColor = .wkBlack45
        self.iconImageView.image = Image.wkSkillChoosePlus
        self.titleLabel.textColor = .wkBlack45
    }
    
    private func setSelectedUI() {
        self.titleView.layer.borderColor = self.abilityBackgroundColor.cgColor
        self.titleView.backgroundColor = self.abilityBackgroundColor
        self.iconImageView.tintColor = self.abilityTintColor
        self.iconImageView.image = Image.wkSkillChooseCheck
        self.titleLabel.textColor = self.abilityTintColor
    }
    
    private func setUI() {
        self.selectionStyle = .none
    }
    
    private func setLayout() {
        self.contentView.addSubview(titleView)
        self.titleView.addSubviews([iconImageView, titleLabel])
        
        self.titleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview()
        }
        
        self.iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6.5)
            make.leading.equalToSuperview().inset(8)
            make.width.equalTo(self.iconImageView.snp.height)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.equalTo(self.iconImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(12)
        }
    }
}
