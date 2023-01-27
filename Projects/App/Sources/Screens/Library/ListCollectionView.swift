//
//  ListCollectionView.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

import SnapKit

class ListCollectionView: UIView {
    
    // MARK: - UIComponents
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Initialzier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubview(collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { ( sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            switch sectionIndex {
            default:
                return ListLayout.create(layoutEnvironment: layoutEnvironment)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: config)
        return layout
    }
    
    private func setDataSource() {
        self.collectionView.register(cell: cellType)
    }
    
}
