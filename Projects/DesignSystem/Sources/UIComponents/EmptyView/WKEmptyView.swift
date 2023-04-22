//
//  WKEmptyView.swift
//  DesignSystem
//
//  Created by yejiyun-MN on 2023/04/22.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

public class WKEmptyView: UIView {
    
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "아직 작성된 기록이 없어요"
        label.font = .h4M
        label.textColor = .wkBlack45
        return label
    }()
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "기록하기 버튼을 눌러\n 워킷을 시작해보세요"
        label.font = .b2M
        label.textColor = .wkBlack30
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubviews([imageView, titleLabel, descriptionLabel])
        
        self.imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(101)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(9)
        }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    public func setImage(image: UIImage) {
        self.imageView.image = image
    }
}
