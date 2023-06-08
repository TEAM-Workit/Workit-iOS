//
//  DetailViewController.swift
//  App
//
//  Created by 윤예지 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import DesignSystem
import UIKit

import ReactorKit
import Mixpanel

class DetailViewController: BaseViewController, View {
    var disposeBag = DisposeBag()
    
    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Item>
    
    enum Item: Hashable {
        case library(Work)
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
    private let emptyView: WKEmptyView = {
        let emptyView = WKEmptyView()
        emptyView.isHidden = true
        emptyView.setImage(image: Image.wkEmpty2)
        return emptyView
    }()
    
    // MARK: - Properties
    
    private let dateChangePublisher = PublishSubject<(Date?, Date?)>()
    
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

        self.setUI()
        self.setNavigationBar()
        self.setLayout()
        self.registerCell()
        self.setDataSource()
        self.trackEmptyView()
    }
    
    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance()
    }
    
    // MARK: - Bind (Reactorkit)
    
    func bind(reactor: DetailReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: DetailReactor) {
        switch previousView {
        case .ability:
            self.rx.viewWillAppear
                .map { _ in Reactor.Action.loadWorksInAbliity }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        case .project:
            self.rx.viewWillAppear
                .map { _ in Reactor.Action.loadWorksInProject }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        }
        
        self.dateButton.rx.tap
            .subscribe(onNext: {
                let bottomSheetViewController = CalendarBottomSheetViewController()
                bottomSheetViewController.modalPresentationStyle = .overFullScreen
                bottomSheetViewController.modalTransitionStyle = .crossDissolve
                bottomSheetViewController.delegate = self
                bottomSheetViewController.canClearAll = true
                
                let start = self.reactor?.currentState.dateRange.startDate
                let end = self.reactor?.currentState.dateRange.endDate
                bottomSheetViewController.setCalenderInitialDate(fromDate: start, toDate: end)
                
                self.present(bottomSheetViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.dateChangePublisher
            .map { Reactor.Action.setDate($0, $1) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: DetailReactor) {
        reactor.state
            .map { $0.works }
            .withUnretained(self)
            .bind { owner, works in
                owner.setDataSource()
                owner.applySnapshot(workit: works)
                owner.emptyView.isHidden = !works.isEmpty
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    func setUI() {
        self.dateButton.setDate(fromDate: nil, toDate: nil)
        self.listCollectionView.collectionView.delegate = self
        if let title = self.reactor?.currentState.title {
            self.navigationItem.title = title
        }
    }
    
    override func setLayout() {
        self.view.addSubviews([dateButton, listCollectionView, emptyView])
        
        self.dateButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
        }

        self.listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dateButton.snp.bottom).offset(12)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-60)
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
                case let .library(workItem):
                    let cell: WKProjectCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                    let workData: WKCellModel = WKCellModel(
                        projectTitle: workItem.project.title,
                        date: workItem.date.toDate(type: .full) ?? Date(),
                        title: workItem.title,
                        description: workItem.description,
                        firstTag: workItem.firstAbilityTag?.name ?? "",
                        firstTagType: workItem.firstAbilityTag?.type ?? .hard,
                        otherCount: workItem.etcAbilityCount
                    )
                    cell.setData(work: workData)
                    return cell
                }
            })
    }
    
    internal func applySnapshot(workit: [Work]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(workit.map { Item.library($0) }, toSection: 0)
        self.dataSource.apply(snapshot)
    }

    func trackEmptyView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addMixpanel(sender:)))
        emptyView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func addMixpanel(sender: UITapGestureRecognizer) {
        Mixpanel.mainInstance().track(event: "모아보기_프로젝트_목록_Clicked")
    }
}

extension DetailViewController: CalendarBottomSheetDelegate {
    func sendSelectedDate(start: Date?, end: Date?) {
        self.dateButton.setDate(fromDate: start, toDate: end)
        self.dateChangePublisher.onNext((start, end))
    }
}

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = WorkDetailViewController()
        viewController.workId = self.reactor?.currentState.works[indexPath.row].id ?? -1
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
