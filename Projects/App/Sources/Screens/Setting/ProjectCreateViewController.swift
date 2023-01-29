//
//  ProjectCreateViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import SnapKit

final class ProjectCreateViewController: BaseViewController {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    enum Text {
        static let viewTitle = "프로젝트 관리"
        static let headerIdentifier = "header"
    }
    
    enum Section: Int, CaseIterable {
        case create
        case projectList
        
        init(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .create
            case 1:
                self = .projectList
            default:
                fatalError()
            }
        }
        
        var title: String {
            switch self {
            case .create:
                return "프로젝트 생성"
            case .projectList:
                return "프로젝트 목록"
            }
        }
    }
    
    enum Item: Hashable {
        case create
        case projectList(String)
    }
    
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: ProjectCreateCollectionViewCell.self)
        collectionView.register(cell: ProjectListCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - Properties
    
    var dataSource: DiffableDataSource!
    let titles = ["정부24프로젝트", "솝텀 프로젝트", "투두메이트 프로젝트"]
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        self.setNavigationBar()
        self.setLayout()
        self.createDataSource()
        self.applySnapshot()
    }
    
    // MARK: - Methods
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance(backgroundColor: .wkWhite)
        self.navigationItem.title = Text.viewTitle
    }
    
    override func setLayout() {
        self.view.addSubview(collectionView)
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionIndex) {
            case .create, .projectList:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                config.backgroundColor = .wkWhite
                let section = NSCollectionLayoutSection.list(
                    using: config,
                    layoutEnvironment: layoutEnvironment)
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 0, leading: 20, bottom: 20, trailing: 20)
                section.boundarySupplementaryItems = [self.createHeaderItem(using: Text.headerIdentifier)]
                return section
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: config)
        return layout
    }
    
    private func createDataSource() {
        self.dataSource = DiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch itemIdentifier {
                case .create:
                    let cell: ProjectCreateCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    return cell
                case .projectList:
                    let cell: ProjectListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.setTitle(self.titles[indexPath.row])
                    return cell
                }
            })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <ProjectHeaderReusableView>(elementKind: Text.headerIdentifier) { supplementaryView, _, indexPath in
            supplementaryView.title.text = Section.allCases[indexPath.section].title
        }
        
        self.dataSource.supplementaryViewProvider = { (_, _, indexPath) -> UICollectionReusableView in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration,
                for: indexPath)
        }
    }
    
    private func createHeaderItem(using elementKind: String) -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .estimated(80))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: layoutSectionHeaderSize,
            elementKind: elementKind,
            alignment: .top)
        
        return layoutSectionHeader
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.create, .projectList])
        snapshot.appendItems([Item.create], toSection: .create)
        snapshot.appendItems(titles.map { Item.projectList($0) }, toSection: .projectList)
        self.dataSource.apply(snapshot)
    }
}
