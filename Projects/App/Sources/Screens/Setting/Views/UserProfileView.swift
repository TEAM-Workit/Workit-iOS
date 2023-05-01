//
//  UserProfileView.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/24.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import SnapKit

class UserProfileView: UIView {
    
    // MARK: - UIComponents
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkMainPurple
        return view
    }()
    
    private let containerView = UIView()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .h3B
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .b1M
        label.textColor = .wkSubPurple45
        return label
    }()
    
    // MARK: - Initalizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
        self.setUI()
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
        self.backgroundColor = .wkWhite
        self.containerView.backgroundColor = UIColor.white
        self.containerView.makeRounded(radius: 5)
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.wkBlack4.cgColor
    }
    
    private func setShadowUI() {
        self.containerView.layer.shadowColor = UIColor.wkBlack5.cgColor
        self.containerView.layer.shadowOpacity = 1
        self.containerView.layer.shadowRadius = 10
        self.containerView.layer.masksToBounds = false
    }
    
    private func setLayout() {
        self.addSubviews([backgroundView, containerView])
        self.containerView.addSubviews([usernameLabel, emailLabel])
        
        self.backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
        
        self.containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(94)
        }

        self.usernameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(23)
            make.leading.equalToSuperview().offset(14)
        }

        self.emailLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.leading.equalTo(usernameLabel.snp.leading)
            make.bottom.equalToSuperview().offset(-23)
        }
    }
    
    func setUsername(text: String) {
        self.usernameLabel.text = text
    }
    
    func setEmail(text: String) {
        self.emailLabel.text = text
    }
    
}
