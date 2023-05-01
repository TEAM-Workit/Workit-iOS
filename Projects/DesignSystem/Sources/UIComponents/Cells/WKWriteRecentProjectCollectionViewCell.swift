//
//  WKWriteRecentProjectCollectionViewCell.swift
//  DesignSystem
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global
import UIKit

import SnapKit

public struct RecentProject {
    public var id: Int = 0
    public var title: String = ""
    
    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    public init() {}
}

public final class WKWriteRecentProjectCollectionViewCell: UICollectionViewCell {
    
    // MARK: UIComponents
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .b1Sb
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Properties
    
    public override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setSelectedUI()
            } else {
                self.setDeselectedUI()
            }
        }
    }
    
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
        self.contentView.makeRounded(radius: 29 / 2)
        self.contentView.layer.borderWidth = 1
        self.setDeselectedUI()
    }
    
    private func setLayout() {
        self.contentView.addSubview(titleLabel)
        
        self.titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setDeselectedUI() {
        self.contentView.backgroundColor = .wkWhite
        self.titleLabel.textColor = .wkBlack
        self.contentView.layer.borderColor = UIColor.wkBlack15.cgColor
    }
    
    private func setSelectedUI() {
        self.contentView.backgroundColor = .wkMainNavy
        self.titleLabel.textColor = .wkWhite
        self.contentView.layer.borderColor = UIColor.wkMainNavy.cgColor
    }
    
    public func setData(data: RecentProject) {
        self.titleLabel.text = data.title
        self.titleLabel.sizeToFit()
    }
    
    public func titleLabelWidth() -> CGFloat {
        return self.titleLabel.frame.width
    }
}
