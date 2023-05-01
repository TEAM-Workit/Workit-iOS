//  
//  LibraryCollectionViewCell.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import DesignSystem
import UIKit

final class LibraryCollectionViewCell: UICollectionViewCell {
    
    enum Text {
        static let totalRecord = "총 ${count}개의 기록"
    }
    
    // MARK: - UIComponents
    
    private let recordLabel = WKTagLabel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.h4Sb
        label.textColor = UIColor.black
        return label
    }()
    
    // MARK: - Initalizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUI()
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.recordLabel.type = .hard
        self.setBackgroundUI()
        self.setShadowUI()
    }
    
    private func setBackgroundUI() {
        self.backgroundColor = UIColor.white
        self.makeRounded(radius: 5)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.wkBlack4.cgColor
    }
    
    private func setShadowUI() {
        self.layer.shadowColor = UIColor.wkBlack5.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.masksToBounds = false
    }
    
    private func setLayout() {
        self.addSubviews([recordLabel, titleLabel])
        
        self.recordLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(17)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(recordLabel.snp.leading)
            make.top.equalTo(recordLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-17)
        }
    }
    
    public func setData(record: LibraryItem) {
        self.recordLabel.text = Text.totalRecord.replacingOccurrences(of: "${count}", with: "\(record.count)")
        self.titleLabel.text = record.name
    }
    
}
