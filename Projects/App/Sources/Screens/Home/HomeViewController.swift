//
//  HomeViewController.swift
//  App
//
//  Created by 김혜수 on 2022/11/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

struct Workit: Hashable {
    let uuid = UUID()
    let title: String

    static func getData() -> [Workit] {
        return [Workit(title: "zz"),
                Workit(title: "zz"),
                Workit(title: "zz"),
                Workit(title: "zz"),
                Workit(title: "zz"),
                Workit(title: "zz"),
                Workit(title: "zz")]
    }
}

final class HomeViewController: UIViewController {

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    enum Section: Int {
        case empty
        case myWorkit
    }

    enum Item: Hashable {
        case empty
        case workit(Workit)
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: WKEmptyCollectionViewCell.self)
        collectionView.register(cell: WKProjectCollectionViewCell.self)
        collectionView.registerHeader(MyWorkitHeaderView.self)
        return collectionView
    }()

    // MARK: - Properties

    var dataSource: DiffableDataSource!

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setUI()
        setLayout()
        setDataSource()
        applySnapshot(workits: Workit.getData())
    }

    // MARK: - Methods

    private func setUI() {
        self.view.backgroundColor = .wkMainPurple
    }

    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance(
            backgroundColor: .clear,
            tintColor: .wkWhite)
        let button = WKNavigationButton(image: Image.wkMenu)
        let barbuttonitem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barbuttonitem
    }

    private func setLayout() {
        self.view.addSubviews([collectionView])

        self.collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionIndex) {
            case .empty:
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(200)),
                    subitems: [item])
                return NSCollectionLayoutSection(group: group)

            case .myWorkit:
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                config.backgroundColor = .wkWhite
                let section = NSCollectionLayoutSection.list(
                    using: config,
                    layoutEnvironment: layoutEnvironment)
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 20, leading: 20, bottom: 104, trailing: 20)
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(66))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
                section.boundarySupplementaryItems = [header]
                header.pinToVisibleBounds = true
                return section

            case .none:
                fatalError()
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
                case .empty:
                    let cell: WKEmptyCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    return cell
                case .workit:
                    let cell: WKProjectCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    cell.setData()
                    return cell
                }
            })

        self.dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) -> UICollectionReusableView in
            let header: MyWorkitHeaderView = collectionView.dequeueHeaderView(for: indexPath)
            return header
        }
    }

    internal func applySnapshot(workits: [Workit]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.empty, .myWorkit])
        snapshot.appendItems([Item.empty], toSection: .empty)
        snapshot.appendItems(workits.map { Item.workit($0) }, toSection: .myWorkit)
        self.dataSource.apply(snapshot)
    }
}
