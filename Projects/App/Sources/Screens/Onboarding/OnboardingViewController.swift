//
//  OnboardingViewController.swift
//  App
//
//  Created by 김혜수 on 2023/01/13.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit

final class OnboardingViewController: BaseViewController, View {
    
    enum Number {
        static let onboardingPageCount = 3
    }

    typealias Reactor = OnboardingReactor
    typealias OnboardingDataSource = UICollectionViewDiffableDataSource<Int, Onboarding>
    typealias OnboardingSnapshot = NSDiffableDataSourceSnapshot<Int, Onboarding>
    
    // MARK: - UIComponenets

    private let nextButton = WKRoundedButton()

    private let pageControl = OnboardingPageControl()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(cell: OnboardingCollectionViewCell.self)
        return collectionView
    }()
    
    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    var dataSource: OnboardingDataSource!
    private let scrollPublisher = PublishSubject<(Int)>()

    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)

        self.setCollectionViewDataSource()
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Bind (ReactorKit)

    func bind(reactor: OnboardingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindAction(reactor: OnboardingReactor) {
        self.rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.scrollPublisher
            .distinctUntilChanged()
            .observe(on: MainScheduler.asyncInstance)
            .map { Reactor.Action.collectionViewScrolled($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.nextButton.rx.tap
            .map { _ in Reactor.Action.nextButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindState(reactor: OnboardingReactor) {
        reactor.state
            .map { $0.onboardings }
            .withUnretained(self)
            .bind { owner, onboardings in
                owner.applyOnboardingSnapshot(onboardings: onboardings)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.page }
            .withUnretained(self)
            .bind { owner, page in
                owner.collectionView.scrollToItem(
                    at: IndexPath(item: page, section: 0),
                    at: .centeredHorizontally,
                    animated: true)
                owner.pageControl.setPage(page: page)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.buttonTitle }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, title in
                owner.nextButton.setTitle(title, for: .normal)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.startButtonTap }
            .distinctUntilChanged()
            .filter { $0 }
            .bind { _ in
                RootViewChange.shared.setRootViewController(.login)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setLayout() {
        self.view.addSubviews([nextButton, pageControl, collectionView])

        self.nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(48)
        }

        self.pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(self.nextButton.snp.top).offset(-28)
            make.width.equalTo(65)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.pageControl.snp.top)
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] (_, offset, env) -> Void in
            self?.scrollPublisher
                .onNext(Int((offset.x / env.container.contentSize.width).rounded(.toNearestOrAwayFromZero)))
        }
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func setCollectionViewDataSource() {
        dataSource = OnboardingDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let cell: OnboardingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
                cell.setData(onboarding: itemIdentifier)
                return cell
            })
    }

    internal func applyOnboardingSnapshot(onboardings: [Onboarding]) {
        var snapshot = OnboardingSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(onboardings, toSection: 0)
        dataSource.apply(snapshot)
    }
}
