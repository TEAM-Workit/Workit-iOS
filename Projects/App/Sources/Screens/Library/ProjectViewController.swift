//
//  ProjectViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

class ProjectViewController: UIViewController, PageTabProtocol  {

    var pageTitle: String {
        return "프로젝트로 보기"
    }
    
    private var collectionView = ListCollectionView()
    
    override func viewDidLoad() {
        self.setLayout()
        self.applySnapshot()
    }
    
    private func setLayout() {
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func applySnapshot() {
        collectionView.applySnapshot(record: Record.getData())
    }
    
}
