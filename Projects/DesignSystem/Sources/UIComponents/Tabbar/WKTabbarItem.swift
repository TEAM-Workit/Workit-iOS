//
//  WKTabbarItem.swift
//  DesignSystem
//
//  Created by 윤예지 on 2022/12/14.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import SnapKit

public class WKTabbarItem: UIView {

    // MARK: - UI Components
    
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()
    var selectedImage = UIImage()
    var deselectedImage = UIImage()
    
    // MARK: - Properties
    
    var isSelected = false {
        didSet {
            setUI()
        }
    }
    
    var selectedColor: UIColor = .white {
        didSet {
            setUI()
        }
    }
    
    var deselectedColor: UIColor = .white {
        didSet {
            setUI()
        }
    }

    // MARK: - Initializer
    
    init(selectedImage: UIImage = UIImage(),
         deselectedImage: UIImage = UIImage(),
         selectedColor: UIColor,
         deselectedColor: UIColor) {
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 39))
        
        self.selectedImage = selectedImage
        self.deselectedImage = deselectedImage
        self.selectedColor = selectedColor
        self.deselectedColor = deselectedColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.titleLabel.textColor = isSelected ? selectedColor : deselectedColor
        self.imageView.image = isSelected ? selectedImage : deselectedImage
    }
    
    private func setLayout() {
        self.addSubviews([imageView, titleLabel])
        
        self.imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
 
    public func setTitle(text: String) {
        self.titleLabel.text = text
    }
    
}
