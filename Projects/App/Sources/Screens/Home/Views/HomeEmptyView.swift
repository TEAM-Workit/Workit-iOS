//
//  HomeEmptyView.swift
//  App
//
//  Created by 김혜수 on 2023/04/30.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

final class HomeEmptyView: UIView {

    private let emptyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.wkEmpty1
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성된 기록이 없어요"
        label.font = .h4M
        label.textColor = .wkBlack45
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기록하기 버튼을 눌러\n워킷을 시작해보세요"
        label.font = .b2M
        label.textColor = .wkBlack30
        label.numberOfLines = 2
        label.setLineSpacing(lineSpacing: 3)
        label.textAlignment = .center
        return label
    }()
    
    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.stackView.axis = .vertical
        
        self.addSubviews([stackView])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(170)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        self.emptyImageView.snp.makeConstraints { make in
            make.height.equalTo(101)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.height.equalTo(19)
        }
        
        self.stackView.addArrangedSubviews([emptyImageView, titleLabel, subtitleLabel])
        self.stackView.setCustomSpacing(9, after: emptyImageView)
        self.stackView.setCustomSpacing(5, after: titleLabel)
    }
}
