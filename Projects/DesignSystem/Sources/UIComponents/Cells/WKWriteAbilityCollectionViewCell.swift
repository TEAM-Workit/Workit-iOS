//
//  WKWriteAbilityCollectionViewCell.swift
//  DesignSystem
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import UIKit

import SnapKit

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
    
    public func setData(data: Ability) {
        self.titleLabel.text = data.name
        self.titleLabel.sizeToFit()
        
        switch data.type {
        case .hard: self.setHardUI()
        case .soft: self.setSoftUI()
        }
    }
    
    public func titleLabelWidth() -> CGFloat {
        return self.titleLabel.frame.width
    }
}
