//
//  AbilityViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Data
import Domain
import DesignSystem
import UIKit

import ReactorKit

class AbilityViewController: BaseViewController, PageTabProtocol, View {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    enum Item: Hashable {
        case library(LibraryItem)
    }
    
    // MARK: - Properties
    
    var pageTitle: String {
        return "역량으로 보기"
    }
    
    var disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    
    private var listCollectionView = ListCollectionView()

    private var dataSource: DiffableDataSource!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        self.setLayout()
        self.setDelegate()
        self.registerCell()
        self.setDataSource()
    }
    
    // MARK: - Bind (Reactorkit)
    
    public func bind(reactor: AbilityReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    public func bindAction(reactor: AbilityReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    public func bindState(reactor: AbilityReactor) {
        reactor.state
            .map { $0.abilities }
            .withUnretained(self)
            .bind { owner, abilities in
                if !abilities.isEmpty {
                    owner.applySnapshot(record: abilities)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    override func setLayout() {
        self.view.addSubview(listCollectionView)
        
        self.listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
    
    internal func applySnapshot(record: [LibraryItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(record.map { Item.library($0) }, toSection: 0)
        self.dataSource.apply(snapshot)
    }
}

extension AbilityViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(previousView: .ability)
        detailViewController.reactor = DetailReactor(
            projectUseCase: DefaultProjectUseCase(
                projectRepository: DefaultProjectRepository()
            ),
            abilityUseCase: DefaultAbilityUseCase(
                abilityRepository: DefaultAbilityRepository()
            ),
            viewType: .ability,
            id: self.reactor?.currentState.abilities[indexPath.row].id ?? 0
        )
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
