//
//  AbilityViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

// swiftlint:disable trailing_whitespace
class AbilityViewController: BaseViewController, PageTabProtocol {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    enum Item: Hashable {
        case library(Record)
    }
    
    // MARK: - Properties
    
    var pageTitle: String {
        return "역량으로 보기"
    }
    
    // MARK: - UIComponents
    
    private var listCollectionView = ListCollectionView()

    private var dataSource: DiffableDataSource!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        self.setLayout()
        self.setDelegate()
        self.registerCell()
        self.setDataSource()
        self.applySnapshot(record: Record.getData())
    }
    
    // MARK: - Methods
    
    override func setLayout() {
        self.view.addSubview(listCollectionView)
        
        self.listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func setDelegate() {
        self.listCollectionView.collectionView.delegate = self
    }
    
    private func registerCell() {
        self.listCollectionView.collectionView.register(cell: LibraryCollectionViewCell.self)
    }
    
    private func setDataSource() {
        self.dataSource = DiffableDataSource(
            collectionView: listCollectionView.collectionView,
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

extension AbilityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(previousView: .ability)
        self.navigationController?.pushViewController(detailViewController, animated: true)
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
