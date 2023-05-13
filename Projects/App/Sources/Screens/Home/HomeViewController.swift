//
//  HomeViewController.swift
//  App
//
//  Created by 김혜수 on 2022/11/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Data
import DesignSystem
import Domain
import UIKit

import ReactorKit
import RxSwift

final class HomeViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    typealias Reactor = HomeReactor

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    enum Section: Int {
        case empty
        case myWorkit

        init(rawValue: Int) {
            switch rawValue {
            case 0:
                self = .empty
            case 1:
                self = .myWorkit
            default:
                fatalError()
            }
        }
    }

    enum Item: Hashable {
        case empty
        case workit(Work)
    }

    // MARK: - UIComponenets
    
    private let bannerView = HomeBannerView()
    private let homeEmptyView: HomeEmptyView = {
        let view = HomeEmptyView()
        view.isHidden = true
        return view
    }()

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
    private var dateChangePublisher = PublishSubject<(Date, Date)>()

    // MARK: - Initializer

    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
    }
    
    func bind(reactor: HomeReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: HomeReactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        dateChangePublisher
            .map { fromDate, toDate in
                Reactor.Action.setDate(fromDate, toDate)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .filter { indexPath in
                indexPath.section == 1
            }
            .withUnretained(self)
            .bind { owner, indexPath in
                let viewController = WorkDetailViewController()
                viewController.workId = owner.reactor?.currentState.works[indexPath.row].id ?? -1
                owner.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: HomeReactor) {
        reactor.state
            .map { $0.works }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, works in
                owner.homeEmptyView.isHidden = !works.isEmpty
                owner.applySnapshot(works: works)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.username }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, name in
                owner.bannerView.setName(name: name)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.dates }
            .withUnretained(self)
            .bind { owner, _ in
                owner.setDataSource()
                owner.applySnapshot(works: owner.reactor?.currentState.works ?? [])
            }
            .disposed(by: disposeBag)
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
        button.addTarget(self, action: #selector(settingButtonDidTap), for: .touchUpInside)
        let barbuttonitem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barbuttonitem
    }
    
    @objc private func settingButtonDidTap() {
        let settingViewController = SettingViewController()
        settingViewController.reactor = SettingReactor(userUseCase: DefaultUserUseCase(userRepository: DefaultUserRepository()))
        let navigationController = WKNavigationConroller(rootViewController: settingViewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }

    override func setLayout() {
        self.view.addSubviews([bannerView, collectionView])
        self.collectionView.addSubview(homeEmptyView)

        self.bannerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview()
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        self.homeEmptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(266 + 80)
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
                    
                case .workit(let workItem):
                    let cell: WKProjectCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    let workData: WKCellModel = WKCellModel(
                        projectTitle: workItem.project.title,
                        date: workItem.date.toDate(type: .full) ?? Date(),
                        title: workItem.title,
                        description: workItem.description,
                        firstTag: workItem.firstAbilityTag?.name ?? "",
                        firstTagType: workItem.firstAbilityTag?.type ?? .hard,
                        otherCount: workItem.etcAbilityCount)
                    cell.setData(work: workData)
                    return cell
                }
            })

        self.dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) -> UICollectionReusableView in
            let header: MyWorkitHeaderView = collectionView.dequeueHeaderView(for: indexPath)
            header.setDate(
                startDate: self.reactor?.currentState.dates.startDate ?? Date(),
                endDate: self.reactor?.currentState.dates.endDate ?? Date())
            header.delegate = self
            return header
        }
    }

    internal func applySnapshot(works: [Work]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.empty, .myWorkit])
        snapshot.appendItems([Item.empty], toSection: .empty)
        snapshot.appendItems(works.map { Item.workit($0) }, toSection: .myWorkit)
        self.dataSource.apply(snapshot)
    }
}

extension HomeViewController: MyWorkitHeaderViewDelegate {
    func dateButtonDidTap() {
        let bottomSheetViewController = CalendarBottomSheetViewController()
        bottomSheetViewController.modalPresentationStyle = .overFullScreen
        bottomSheetViewController.modalTransitionStyle = .crossDissolve
        bottomSheetViewController.delegate = self
        bottomSheetViewController.setCalenderInitialDate(
            fromDate: self.reactor?.currentState.dates.startDate ?? Date(),
            toDate: self.reactor?.currentState.dates.endDate ?? Date())
        self.present(bottomSheetViewController, animated: true)
    }
}

extension HomeViewController: CalendarBottomSheetDelegate {
    func sendSelectedDate(start: Date?, end: Date?) {
        if let start = start,
           let end = end {
            dateChangePublisher.onNext((start, end))
        }
    }
}
