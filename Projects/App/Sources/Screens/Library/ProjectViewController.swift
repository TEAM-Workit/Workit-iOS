//
//  ProjectViewController.swift
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

class ProjectViewController: BaseViewController, PageTabProtocol, View {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    enum Item: Hashable {
        case library(LibraryItem)
    }
    // MARK: - UIComponents
    
    private var listCollectionView = ListCollectionView()

    // MARK: - Properties
    
    var pageTitle: String {
        return "프로젝트로 보기"
    }
    private var dataSource: DiffableDataSource!
    
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.setDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.setLayout()
        self.setDelegate()
        self.registerCell()
        self.setDataSource()
    }
    
    // MARK: - Bind (Reactorkit)
    
    public func bind(reactor: ProjectReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    public func bindAction(reactor: ProjectReactor) {
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    public func bindState(reactor: ProjectReactor) {
        reactor.state
            .map { $0.projects }
            .withUnretained(self)
            .bind { owner, projects in
                owner.applySnapshot(record: projects)
            }
            .disposed(by: disposeBag)
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
    
    internal func applySnapshot(record: [LibraryItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(record.map { Item.library($0) }, toSection: 0)
        self.dataSource.apply(snapshot)
    }
}

extension ProjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController(previousView: .project)
        detailViewController.reactor = DetailReactor(
            title: self.reactor?.currentState.projects[indexPath.row].name ?? "",
            projectUseCase: DefaultProjectUseCase(
                projectRepository: DefaultProjectRepository()
            ),
            abilityUseCase: DefaultAbilityUseCase(
                abilityRepository: DefaultAbilityRepository()
            ),
            viewType: .project,
            id: self.reactor?.currentState.projects[indexPath.row].id ?? 0
        )
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
