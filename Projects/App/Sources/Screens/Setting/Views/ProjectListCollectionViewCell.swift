//
//  ProjectListCollectionViewCell.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

class ProjectListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let projectTitleView: UILabel = {
        let label = UILabel()
        label.font = .b1M
        label.textColor = .wkBlack65
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack15
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.wkKebapB, for: .normal)
        return button
    }()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubviews([projectTitleView, editButton, separatorView])
        
        self.projectTitleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
        }
        
        self.editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.separatorView.snp.makeConstraints { make in
            make.top.equalTo(projectTitleView.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setTitle(_ text: String) {
        self.projectTitleView.text = text
    }
    
}
