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
import RxSwift
import SnapKit

final class OnboardingViewController: BaseViewController, View {
    
    enum Text {
        static let next = "다음"
    }

    typealias Reactor = OnboardingReactor
    typealias OnboardingDataSource = UICollectionViewDiffableDataSource<Int, Onboarding>
    typealias OnboardingSnapshot = NSDiffableDataSourceSnapshot<Int, Onboarding>
    
    // MARK: - UIComponenets

    private let nextButton: WKRoundedButton = {
        let button = WKRoundedButton()
        button.setTitle(Text.next, for: .normal)
        return button
    }()

    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.register(cell: OnboardingCollectionViewCell.self)
        return collectionView
    }()

    // MARK: - Properties
    
    var disposeBag = DisposeBag()
    var dataSource: OnboardingDataSource!

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
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.viewWillAppear }
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
    }
    
    // MARK: - Methods

    override func setLayout() {
        self.view.addSubviews([nextButton, dotView, collectionView])

        self.nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(48)
        }

        self.dotView.snp.makeConstraints { make in
            make.bottom.equalTo(self.nextButton.snp.top).offset(-28)
            make.width.equalTo(65)
            make.height.equalTo(10)
            make.centerX.equalToSuperview()
        }

        self.collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.dotView.snp.top)
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
        section.orthogonalScrollingBehavior = .groupPaging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func setCollectionViewDataSource() {
        dataSource = OnboardingDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
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
