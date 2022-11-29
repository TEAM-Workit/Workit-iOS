//
//  WKCapabilityAddButton.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

public class WKCapabilityAddButton: UIButton {
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

extension WKCapabilityAddButton {
    private func setDefaultStyle() {
        self.backgroundColor = .wkBlack8
        self.setImage(Image.wkCapabilityPlus, for: .normal)
        self.titleLabel?.font = .b1Sb
        self.setTitleColor(.wkBlack45, for: .normal)
        self.setTitleColor(.wkBlack80, for: .highlighted)
        self.makeRounded(radius: 5)
        self.imageView?.snp.updateConstraints { make in
            make.top.bottom.equalToSuperview().inset(6.5)
            make.leading.equalToSuperview().inset(6)
            make.width.equalTo(self.imageView?.snp.height ?? 16)
        }
        
    }
}
