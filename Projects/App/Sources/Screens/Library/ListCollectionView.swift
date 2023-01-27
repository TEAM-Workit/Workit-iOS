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
    
    enum Item: Hashable {
        case library(Record)
    }
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    private var dataSource: DiffableDataSource!
    
    // MARK: - UIComponents
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: LibraryCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - Initialzier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
        self.setDataSource()
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
        self.dataSource = DiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .library(let item):
                    let cell: LibraryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.setData(record: item)
                    return cell
                }
            })
    }
    
    internal func applySnapshot(record: [Record]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(record.map { Item.library($0) }, toSection: 0)
        self.dataSource.apply(snapshot)
    }
    
}
