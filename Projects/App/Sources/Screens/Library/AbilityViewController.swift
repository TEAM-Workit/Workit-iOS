//
//  AbilityViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

class AbilityViewController: UIViewController, PageTabProtocol {

    // MARK: - Properties
    
    var pageTitle: String {
        return "역량으로 보기"
    }
    
    // MARK: - UIComponents
    
    private var collectionView = ListCollectionView()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        self.setLayout()
        self.applySnapshot()
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.view.addSubview(collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func applySnapshot() {
        self.collectionView.applySnapshot(record: Record.getData())
    }
    
}

// 임시 모델
struct Record: Hashable {
    let uuid = UUID()
    let count: Int
    let title: String
    
    static func getData() -> [Record] {
        return [
            Record(count: 0, title: "디자이너, 개발자와 긴밀한 소통과 협력"),
            Record(count: 2, title: "디자이너, 개발자와 긴밀한 소통과 협력"),
            Record(count: 5, title: "디자이너, 개발자와 긴밀한 소통과 협력"),
            Record(count: 4, title: "디자이너, 개발자와 긴밀한 소통과 협력"),
            Record(count: 0, title: "디자이너, 개발자와 긴밀한 소통과 협력")
        ]
    }
}
