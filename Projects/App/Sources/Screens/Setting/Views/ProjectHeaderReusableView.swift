//
//  ProjectHeaderReusableView.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

class ProjectHeaderReusableView: UICollectionReusableView {
    
    // MARK: - UIComponents
    
    let title: UILabel = {
        let label = UILabel()
        label.font = .h4Sb
        return label
    }()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubview(title)
        
        self.title.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview().inset(20)
        }
    }
}
