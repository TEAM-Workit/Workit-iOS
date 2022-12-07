//
//  WKStarLabel.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/29.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import SnapKit

public class WKStarLabel: UILabel {
    
    // MARK: UIComponenets
    
    private lazy var starLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "*"
        label.textColor = UIColor.wkMainPurple
        label.font = UIFont.b1Sb
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension WKStarLabel {
    private func setDefaultLayout() {
        self.addSubview(starLabel)
        
        starLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(self.snp.trailing)
            make.width.equalTo(9)
            make.height.equalTo(10)
        }
    }
}
