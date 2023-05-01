//
//  SearchProjectTableViewCell.swift
//  App
//
//  Created by madilyn on 2023/01/30.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Data
import DesignSystem
import Global
import UIKit

import SnapKit

final class SearchProjectTableViewCell: UITableViewCell {
    
    // MARK: UIComponents
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .b1M
        label.textColor = .wkBlack
        return label
    }()
    
    private let createLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "생성하기"
        label.font = .b1M
        label.textColor = .wkBlack45
        label.sizeToFit()
        return label
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
    
    func setData(data: SearchProjectTableViewCellModel) {
        self.titleLabel.text = data.title
    }
}

// MARK: - UI

extension SearchProjectTableViewCell {
    
    func setUI() {
        self.createLabel.isHidden = true
        self.contentView.backgroundColor = .wkWhite
    }
    
    func setCreateUI() {
        self.createLabel.isHidden = false
        self.contentView.backgroundColor = .wkBlack4
    }
    
    private func setLayout() {
        self.contentView.addSubviews([createLabel, titleLabel])
        
        self.createLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(50)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(self.createLabel.snp.leading).offset(8)
        }
    }
}

struct SearchProjectTableViewCellModel: Hashable {
    var id: Int
    var title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
