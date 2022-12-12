//
//  WKTagLabel.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/12/09.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit.UILabel

public final class WKTagLabel: PaddingLabel {

    enum Number {
        static let top: CGFloat = 6
        static let left: CGFloat = 8
        static let bottom: CGFloat = 6
        static let right: CGFloat = 8
    }
    
    // MARK: - Properties
    
    public var type: TagType {
        didSet {
            self.setColor(type: type)
        }
    }

    // MARK: - LifeCycle
    
    init(type: TagType = .hard) {
        self.type = type
        super.init(padding: UIEdgeInsets(
            top: Number.top,
            left: Number.left,
            bottom: Number.bottom,
            right: Number.right)
        )
        self.setUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.font = UIFont.c2M
        self.makeRounded(radius: 5)
    }
    
    private func setColor(type: TagType) {
        switch type {
        case .hard:
            self.backgroundColor = .wkSubPurple15
            self.textColor = .wkMainPurple
        case .soft:
            self.backgroundColor = .wkSubNavy20
            self.textColor = .wkMainNavy
        }
    }
}
