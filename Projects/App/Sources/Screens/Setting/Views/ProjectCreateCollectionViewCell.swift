//
//  ProjectCreateCollectionViewCell.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

class ProjectCreateCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let textField = UITextField()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack45
        return view
    }()
    private let nextButton = WKRoundedButton()
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.textField.placeholder = "새로운 프로젝트명을 입력하세요."
        self.nextButton.setTitle("생성", for: .normal)
    }
    
    private func setLayout() {
        self.addSubviews([textField, underlineView, nextButton])
        
        self.textField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalTo(nextButton.snp.leading).offset(-10)
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.trailing.equalTo(textField.snp.trailing)
            make.height.equalTo(1)
        }
        
        self.nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(35)
        }
    }
    
}
