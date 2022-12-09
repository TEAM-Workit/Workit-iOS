//
//  BaseViewController.swift
//  App
//
//  Created by madilyn on 2022/12/10.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

class BaseViewController: UIViewController {
    
    // MARK: Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setBackgroundColor()
    }
}

// MARK: - UI

extension BaseViewController {
    private func setBackgroundColor() {
        self.view.backgroundColor = .wkWhite
    }
    
    @objc
    func setLayout() {
        
    }
}
