//
//  DetailViewController.swift
//  App
//
//  Created by 윤예지 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

class DetailViewController: BaseViewController {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    enum Item: Hashable {
        case library(Workit)
    }
    
    enum PreviousView {
        case ability
        case project
    }
    
    private var previousView: PreviousView
    private var dataSource: DiffableDataSource!
    
    // MARK: - UIComponents
    
    private let dateButton = WKDateButton(fromDate: Date())
    private var listCollectionView: ListCollectionView = ListCollectionView()
    
    // MARK: - Initializer
    
    init(previousView: PreviousView) {
        self.previousView = previousView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBar()
        self.setLayout()
        self.registerCell()
        self.setDataSource()
        self.applySnapshot(workit: Workit.getData())
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance()
        self.navigationItem.title = previousView == .ability ? "역량으로 보기 상세" : "프로젝트로 보기 상세"
    }
    
    // MARK: - Methods
    
    override func setLayout() {
        self.view.addSubviews([dateButton, listCollectionView])
        
        self.dateButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
        }

        self.listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }

    private func registerCell() {
        self.listCollectionView.collectionView.register(cell: WKProjectCollectionViewCell.self)
    }
    
    private func setDataSource() {
        self.dataSource = DiffableDataSource(
            collectionView: listCollectionView.collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .library:
                    let cell: WKProjectCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                 //   cell.setData()
                    return cell
                }
            })
    }
    
    internal func applySnapshot(workit: [Workit]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(workit.map { Item.library($0) }, toSection: 0)
        self.dataSource.apply(snapshot)
    }

}
