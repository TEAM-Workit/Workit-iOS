//
//  ProjectCreateView.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import ReactorKit

class ProjectCreateView: UIView {
    
    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .h4Sb
        label.text = "프로젝트 생성"
        return label
    }()
    let textField = UITextField()
    let createButton = WKRoundedButton()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack45
        return view
    }()
    
    // MARK: - Properties
    
    var disposeBag: DisposeBag = DisposeBag()
    
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
        self.createButton.setTitle("생성", for: .normal)
    }
    
    private func setLayout() {
        self.addSubviews([titleLabel, textField, underlineView, createButton])
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(createButton.snp.leading).offset(-10)
        }
        
        self.underlineView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(textField.snp.trailing)
            make.height.equalTo(1)
        }
        
        self.createButton.snp.makeConstraints { make in
            make.centerY.equalTo(textField)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(65)
            make.height.equalTo(35)
        }
    }
    
}
