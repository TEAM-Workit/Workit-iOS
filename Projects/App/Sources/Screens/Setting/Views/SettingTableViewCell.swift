//
//  SettingTableViewCell.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/24.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    enum `Type` {
        case `default`
        case subtitle
        case toggle
    }
    
    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h4M
        return label
    }()
    
    public let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .h4M
        label.textColor = .wkBlack45
        return label
    }()
    
    private let nextImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.wkArrowSmallNext
        return imageView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack15
        return view
    }()
    
    public lazy var toggle: WKToggle = {
        let toggle = WKToggle()
        return toggle
    }()
    
    public var type: `Type` = .default {
        didSet {
            self.setLayout()
        }
    }
    
    // MARK: - Initalizer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubviews([titleLabel, subTitleLabel, nextImageView, separatorView, toggle])
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        if self.type == .subtitle {
            self.subTitleLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            }
        } else {
            self.subTitleLabel.removeFromSuperview()
        }
        
        self.nextImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
        }
        
        self.separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        if self.type == .toggle {
            self.toggle.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(20)
            }
        } else {
            self.toggle.removeFromSuperview()
        }
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
}
