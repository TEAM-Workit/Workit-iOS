//
//  ProjectViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

class ProjectViewController: UIViewController, PageTabProtocol {

    // MARK: - Properties
    
    var pageTitle: String {
        return "프로젝트로 보기"
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func applySnapshot() {
        collectionView.applySnapshot(record: Record.getData())
    }
    
}
