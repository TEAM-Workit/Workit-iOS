//
//  ProjectManagementViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import DesignSystem
import UIKit
import Global

import SnapKit
import ReactorKit

final class ProjectManagementViewController: BaseViewController, View {
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Project>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Project>
    
    enum Text {
        static let viewTitle = "프로젝트 관리"
        static let headerIdentifier = "header"
        static let deleteAlertTitle = "프로젝트를 삭제합니다."
        static let deleteAlertDescription = "프로젝트를 삭제하면 속해있는\n 업무 기록이 모두 삭제됩니다."
        static let modifyAlertTitle = "프로젝트명 수정"
        static let confirm = "확인"
        static let cancel = "취소"
        static let modify = "수정"
        static let delete = "삭제"
    }
    
    enum Section: Int, CaseIterable {
        case projectList
        
        init(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .projectList
            default:
                fatalError()
            }
        }
        
        var title: String {
            switch self {
            case .projectList:
                return "프로젝트 목록"
            }
        }
    }
    enum SectionKind: Int {
        case projectList
    }
    // MARK: - UI Components
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(cell: ProjectListCollectionViewCell.self)
        return collectionView
    }()
    
    private let projectCreateView = ProjectCreateView()
    
    // MARK: - Properties
    
    var dataSource: DiffableDataSource!
    var disposeBag: DisposeBag = DisposeBag()
    var modifyConfirmSubject: BehaviorSubject<(String?, Int?)> = .init(value: (nil, nil))
    var deleteConfirmSubject: BehaviorSubject<Int?> = .init(value: nil)
    var selectedProjectId: Int = -1
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        self.view.backgroundColor = .wkWhite
        self.navigationController?.isNavigationBarHidden = false
        self.setNavigationBar()
        self.setLayout()
        self.createDataSource()
    }
    
    // MARK: - Bind (ReactorKit)
    
    func bind(reactor: ProjectManagementReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ProjectManagementReactor) {
        self.rx.viewDidLoad
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.projectCreateView.textField.rx.text
            .map { Reactor.Action.setTitle($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.projectCreateView.createButton.rx.tap
            .map { Reactor.Action.createButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.projectCreateView.textField.rx.text
            .map { Reactor.Action.setNewProjectTitle($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.modifyConfirmSubject
            .map { Reactor.Action.modifyButtonTapped($0, $1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.deleteConfirmSubject
            .map { Reactor.Action.deleteButtonTapped($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: ProjectManagementReactor) {
        reactor.state
            .map { $0.projectList }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, projects in
                owner.applySnapshot(projects: projects)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnableCreateButton }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isEnableCreateButton in
                owner.projectCreateView.createButton.isEnabled = isEnableCreateButton
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.newProjectTitle }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, text in
                owner.projectCreateView.textField.text = text
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isShowingToast }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, isShowingToast in
                if isShowingToast && reactor.currentState.isDuplicatedProject {
                    owner.showToast(message: "이미 생성된 프로젝트입니다.", font: .b2M)
                }
            }
            .disposed(by: disposeBag)
            
    }

    // MARK: - Methods
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance(backgroundColor: .wkWhite)
        self.navigationItem.title = Text.viewTitle
    }
    
    override func setLayout() {
        self.view.addSubviews([projectCreateView, collectionView])
        
        self.projectCreateView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
            
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(projectCreateView.snp.bottom).offset(15)
            make.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
            switch Section(rawValue: sectionIndex) {
            case .projectList:
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
                let cell: ProjectListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setTitle(itemIdentifier.title)
                cell.setProject(itemIdentifier)
                cell.editButton.rx.tap
                    .bind(onNext: {
                        self.bindPopup(itemIdentifier: itemIdentifier)
                    })
                    .disposed(by: self.disposeBag)
                
                cell.rx.deleteButtonDelegate
                    .asObservable()
                    .withUnretained(self)
                    .bind(onNext: { _, projectId in
                        self.selectedProjectId = projectId
                    })
                    .disposed(by: self.disposeBag)
                return cell
            })
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <ProjectHeaderReusableView>(elementKind: Text.headerIdentifier) { supplementaryView, _, indexPath in
            supplementaryView.title.text = Section.allCases[indexPath.section].title
            supplementaryView.backgroundColor = .wkWhite
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
        layoutSectionHeader.pinToVisibleBounds = true
        
        return layoutSectionHeader
    }
    
    private func applySnapshot(projects: [Project]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.projectList])
        snapshot.appendItems(projects)
        self.dataSource.apply(snapshot)
    }
    
    private func deleteItemToDataSource(with identifier: Project) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([identifier])
        dataSource.apply(snapshot)
    }
    
    private func bindPopup(itemIdentifier: Project) {
        let sheetReactor = ProjectManagementAlertReactor(projectID: 0)
        let sheetController = AlertController<ProjectManagementAlertAction>(
            reactor: sheetReactor,
            preferredStyle: .actionSheet
        )
        self.present(sheetController, animated: true, completion: nil)
        
        sheetController.rx.actionSelected
            .subscribe(onNext: { action in
                switch action {
                case .modify:
                    let alert = UIAlertController(
                        title: Text.modifyAlertTitle,
                        message: nil,
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: Text.cancel, style: .cancel))
                    alert.addAction(UIAlertAction(title: Text.confirm, style: .default) { _ in
                        if let projectName = alert.textFields?[0].text {
                            self.modifyConfirmSubject.onNext((projectName, self.selectedProjectId))
                        }
                    })
                    alert.addTextField { textfield in
                        guard let index = self.reactor?.currentState.projectList.firstIndex(where: { item in
                            item.id == itemIdentifier.id
                        }) else { return }
                        textfield.text = self.reactor?.currentState.projectList[index].title
                    }
                    
                    self.present(alert, animated: true, completion: nil)
                case .delete:
                    let alert = UIAlertController(title: Text.deleteAlertTitle,
                                                  message: Text.deleteAlertDescription,
                                                  preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: Text.cancel, style: .cancel))
                    alert.addAction(UIAlertAction(title: Text.confirm, style: .default) { _ in
                        self.deleteItemToDataSource(with: itemIdentifier)
                        self.deleteConfirmSubject.onNext(self.selectedProjectId)
                    })
                    
                    self.present(alert, animated: true, completion: nil)
                case .cancel:
                    break
                }
            })
            .disposed(by: self.disposeBag)
    }
}
