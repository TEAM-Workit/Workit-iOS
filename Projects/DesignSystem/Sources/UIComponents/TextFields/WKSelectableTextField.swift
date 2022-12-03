//
//  WKSelectableTextField.swift
//  DesignSystem
//
//  Created by madilyn on 2022/11/25.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

public class WKSelectableTextField: WKTextField {
    
    // MARK: UIComponents
    
    private let button: UIButton = UIButton(type: .system)
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Methods
    
    public func setAction(_ closure: @escaping () -> Void) {
        self.button.addAction( UIAction { _ in closure() }, for: .touchUpInside)
    }
}

// MARK: - UI

extension WKSelectableTextField {
    private func setDefaultLayout() {
        self.removeClearButton()
        self.addSubview(button)
        
        self.button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
