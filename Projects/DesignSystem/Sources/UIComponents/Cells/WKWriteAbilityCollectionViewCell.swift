//
//  WKWriteAbilityCollectionViewCell.swift
//  DesignSystem
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

public struct WriteAbility {
    public var abilityId: Int = 0
    public var abilityName: String = ""
    public var abilityType: String = ""
    
    public init(abilityId: Int, abilityName: String, abilityType: String) {
        self.abilityId = abilityId
        self.abilityName = abilityName
        self.abilityType = abilityType
    }
    
    public init() {}
}

public final class WKWriteAbilityCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIComponents
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .b1Sb
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.contentView.makeRounded(radius: 5)
    }
    
    private func setLayout() {
        self.contentView.addSubview(titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setHardUI() {
        self.contentView.backgroundColor = .wkSubNavy20
        self.titleLabel.textColor = .wkMainNavy
    }
    
    private func setSoftUI() {
        self.contentView.backgroundColor = .wkSubPurple15
        self.titleLabel.textColor = .wkMainPurple
    }
    
    public func setData(data: WriteAbility) {
        self.titleLabel.text = data.abilityName
        self.titleLabel.sizeToFit()
        
        if data.abilityType == "HARD" {
            self.setHardUI()
        } else {
            self.setSoftUI()
        }
    }
    
    public func titleLabelWidth() -> CGFloat {
        return self.titleLabel.frame.width
    }
}
