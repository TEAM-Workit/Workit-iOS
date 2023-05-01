//
//  WKProjectSearchTextField.swift
//  DesignSystem
//
//  Created by madilyn on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global
import UIKit

import RxCocoa
import RxSwift

public class WKProjectSearchTextField: WKTextField {
    
    // MARK: Properties
    
    private let disposeBag: DisposeBag = DisposeBag()
    public var isEntered: Bool = false {
        didSet {
            if isEntered {
                self.setEnteredStyle()
            }
        }
    }
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUI() {
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
    }
    
    private func setEnteredStyle() {
        self.backgroundColor = .wkBlack4
        self.showClearButton()
    }
}
