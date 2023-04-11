//
//  WorkDetailViewController.swift
//  App
//
//  Created by madilyn on 2023/04/06.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Domain
import Global
import UIKit

import SnapKit

// swiftlint:disable file_length

final class WorkDetailViewController: BaseViewController {
    
    enum Text {
        static let abilityTitle = "역량 태그"
        static let workDescriptionTitle = "업무 내용"
        static let removeAlertTitle = "기록을 삭제하시겠어요?"
        static let removeAlertDetail = "삭제하면 복구할 수 없습니다."
        static let edit = "수정"
        static let remove = "삭제"
        static let cancel = "취소"
        static let descriptionPlaceholder = "업무 내용이 아직 입력되지 않았어요!"
    }
    
    // MARK: - UIComponents
    
    private let navigationBar: WKNavigationBar = {
        let navigationBar: WKNavigationBar = WKNavigationBar()
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: WKNavigationButton(image: Image.wkKebapA))
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: WKNavigationButton(image: Image.wkArrowBig))
        return navigationBar
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = UIView()
    
    private let projectTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .h4Sb
        label.textColor = .wkMainPurple
        return label
    }()
    
    private let workTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .h25b
        label.textColor = .wkBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .h4M
        label.textColor = .wkBlack30
        return label
    }()
    
    private let separatorLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .wkBlack15
        return view
    }()
    
    private let abilityLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.abilityTitle
        label.font = .b1Sb
        label.textColor = .wkBlack85
        return label
    }()
    
    private var hardAbilityCollectionView: WKWriteAbilityCollectionView = WKWriteAbilityCollectionView()
    private var softAbilityCollectionView: WKWriteAbilityCollectionView = WKWriteAbilityCollectionView()
    
    private let hardAbilityFlowLayout: WriteAbilityCollectionViewFlowLayout = WriteAbilityCollectionViewFlowLayout()
    private let softAbilityFlowLayout: WriteAbilityCollectionViewFlowLayout = WriteAbilityCollectionViewFlowLayout()
    
    private let workDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.workDescriptionTitle
        label.font = .b1Sb
        label.textColor = .wkBlack85
        return label
    }()
    
    private let workDescriptionTextView: WKTextView = {
        let textView: WKTextView = WKTextView(isEditable: false)
        textView.setPlaceholder(text: Text.descriptionPlaceholder)
        return textView
    }()
    
    // MARK: Properties
    
    private var softAbilityList: [WriteAbility] = []
    private var hardAbilityList: [WriteAbility] = []
    
    private var dummyWorkData: Work = Work(
        id: 1,
        title: "데일리 지표 확인데일리 지표 확인데일리 지표 확인데일리 지표 확인데일리 지표 확인데일리 지표 확인",
        project: Project(title: "솝텀 워킷 프로젝트"),
        description: "최근 며칠간 리텐션이 지속적으로 떨어진 것을 파악했다.\n\n앱 진입하자마자 보이는 새로운 기능에 대한 홍보 팝업을 보고 앱을 꺼버리는 비율이 늘어난 것 같았다.\n\n팝업 표시 이전과 이번주 리텐션 자료를 비교하기 위해 조회를 해보고 오늘 스크럼에서 이야기를 나눴다.\n\n팀장님이 이 부분에 대해서 마케팅팀과 함께 논의해봐야겠다고 하셔서, 해당 내용에 대해 정리해서 마케팅팀 슬랙에 이슈를 전달했다.위해 조회를 해보고 오늘 스크럼에서 이야기를 나눴다.\n\n팀장님이 이 부분에 대해서 마케팅팀과 함께 논의해봐야겠다고 하셔서, 해당 내용에 대해 정리해서 마케팅팀 슬랙에 이슈를 전달했다.",
        date: "2022-11-13T00:00:00.000Z",
        abilities: [Ability(id: 1, name: "데이터 분석을 통한 서비스 개선", type: "SOFT"), Ability(id: 2, name: "논리적인 커뮤니케이션 능력", type: "SOFT"), Ability(id: 2, name: "지표 분석을 통한 인사이트 도출", type: "HARD")]
    )
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setMenuButtonAction()
        self.setScrollView()
        self.setLayout()
        self.setAbilityCollectionView()
        self.setData(workData: self.dummyWorkData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateAbilityCollectionViewHeight()
    }
    
    // MARK: Methods
    
    private func setMenuButtonAction() {
        if let button = self.navigationBar.topItem?.rightBarButtonItem?.customView as? UIButton {
            button.setAction { [weak self] in
                let actionSheet = UIAlertController(
                    title: nil,
                    message: nil,
                    preferredStyle: .actionSheet
                )
                
                actionSheet.addAction(
                    UIAlertAction(
                        title: Text.edit,
                        style: .default,
                        handler: { [weak self] _ in
                            self?.presentEditViewController()
                        }
                    )
                )
                
                actionSheet.addAction(
                    UIAlertAction(
                        title: Text.remove,
                        style: .destructive,
                        handler: { _ in
                            self?.presentRemoveAlert()
                        }
                    )
                )
                
                actionSheet.addAction(UIAlertAction(title: Text.cancel, style: .cancel, handler: nil))
                
                self?.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    private func setScrollView() {
        self.scrollView.delegate = self
    }
    
    override func setLayout() {
        self.setSubviews()
        self.setBackgroundLayout()
        self.setTitleLayout()
        self.setAbilityLayout()
        self.setWorkDescriptionLayout()
    }
    
    private func setAbilityCollectionView() {
        self.hardAbilityCollectionView.collectionViewLayout = self.hardAbilityFlowLayout
        self.softAbilityCollectionView.collectionViewLayout = self.softAbilityFlowLayout
        
        self.hardAbilityCollectionView.dataSource = self
        self.softAbilityCollectionView.dataSource = self
        
        self.hardAbilityCollectionView.delegate = self
        self.softAbilityCollectionView.delegate = self
        
        self.hardAbilityCollectionView.register(
            cell: WKWriteAbilityCollectionViewCell.self,
            forCellWithReuseIdentifier: "hardCell"
        )
        self.softAbilityCollectionView.register(
            cell: WKWriteAbilityCollectionViewCell.self,
            forCellWithReuseIdentifier: "softCell"
        )
    }
    
    private func setData(workData: Work) {
        self.projectTitleLabel.text = workData.project.title
        self.workTitleLabel.text = workData.title
        self.dateLabel.text = workData.date.toDate(type: .full)?.toString(type: .simpleDot)
        
        let abilities: ([WriteAbility], [WriteAbility]) = self.divideAbilities(abilities: workData.abilities)
        self.softAbilityList = abilities.0
        self.hardAbilityList = abilities.1
        
        self.workDescriptionTextView.text = workData.description
        
        self.projectTitleLabel.sizeToFit()
        self.workTitleLabel.sizeToFit()
        self.workDescriptionTextView.sizeToFit()
        
        self.softAbilityCollectionView.reloadData()
        self.hardAbilityCollectionView.reloadData()
    }
    
    private func updateAbilityCollectionViewHeight() {
        self.hardAbilityCollectionView.snp.updateConstraints { make in
            make.top.equalTo(self.abilityLabel.snp.bottom).offset(self.hardAbilityList.isEmpty ? 0 : 8)
            make.height.equalTo(self.hardAbilityList.isEmpty ? 0 : 29)
        }
        self.softAbilityCollectionView.snp.updateConstraints { make in
            make.height.equalTo(self.softAbilityList.isEmpty ? 0 : 29)
        }
    }
    
    private func divideAbilities(abilities: [Ability]) -> ([WriteAbility], [WriteAbility]) {
        var softAbilites: [WriteAbility] = []
        var hardAbilites: [WriteAbility] = []
        for ability in abilities {
            if ability.type == .soft {
                softAbilites.append(
                    WriteAbility(
                        abilityId: ability.id,
                        abilityName: ability.name,
                        abilityType: ability.type.rawValue
                    )
                )
            } else {
                hardAbilites.append(
                    WriteAbility(
                        abilityId: ability.id,
                        abilityName: ability.name,
                        abilityType: ability.type.rawValue
                    )
                )
            }
        }
        return (softAbilites, hardAbilites)
    }
    
    private func presentRemoveAlert() {
        let actionSheet = UIAlertController(
            title: Text.removeAlertTitle,
            message: Text.removeAlertDetail,
            preferredStyle: .alert
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: Text.cancel,
                style: .default,
                handler: nil
            )
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: Text.remove,
                style: .destructive,
                handler: { [weak self] _ in
                    self?.requestRemoveWork()
                }
            )
        )
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func presentEditViewController() {
        let editViewController: BaseViewController = WriteViewController()
        
        self.present(editViewController, animated: true)
    }
}

// MARK: - Extension (UICollectionViewDataSource)

extension WorkDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.hardAbilityCollectionView:
            return self.hardAbilityList.count
        case self.softAbilityCollectionView:
            return self.softAbilityList.count
        default: return 0
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        switch collectionView {
        case self.hardAbilityCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "hardCell",
                for: indexPath
            ) as? WKWriteAbilityCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.setData(data: self.hardAbilityList[indexPath.row])
            
            return cell
        case self.softAbilityCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "softCell",
                for: indexPath
            ) as? WKWriteAbilityCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.setData(data: self.softAbilityList[indexPath.row])
            
            return cell
        default: return UICollectionViewCell()
        }
    }
}

// MARK: - Extension (UICollectionViewDelegateFlowLayout)

extension WorkDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sizingCell = WKWriteAbilityCollectionViewCell()
        
        switch collectionViewLayout {
        case self.hardAbilityFlowLayout:
            sizingCell.setData(data: hardAbilityList[indexPath.row])
        case self.softAbilityFlowLayout:
            sizingCell.setData(data: softAbilityList[indexPath.row])
        default: return .zero
        }
        
        let cellWidth = sizingCell.titleLabelWidth() + 20
        let cellHeight = 29
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }
}

// MARK: - Extension (UIScrollViewDelegate)

extension WorkDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let limitOffset: CGFloat = self.workTitleLabel.frame.minY
        
        if scrollView.contentOffset.y <= limitOffset {
            self.navigationBar.topItem?.title = ""
        } else {
            self.navigationBar.topItem?.title = self.workTitleLabel.text
        }
     }
}

// MARK: - Network

extension WorkDetailViewController {
    private func requestRemoveWork() {
        debugPrint("삭제 request")
    }
}

// MARK: - UI

extension WorkDetailViewController {
    private func setSubviews() {
        self.view.addSubviews([navigationBar, scrollView])
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews([
            projectTitleLabel, workTitleLabel,
            dateLabel, separatorLineView,
            abilityLabel, hardAbilityCollectionView,
            softAbilityCollectionView, workDescriptionLabel,
            workDescriptionTextView
        ])
    }
    
    private func setBackgroundLayout() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
    }
    
    private func setTitleLayout() {
        self.projectTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.workTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(projectTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(workTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        self.separatorLineView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
    }
    
    private func setAbilityLayout() {
        self.abilityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.separatorLineView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(18)
        }
        
        self.hardAbilityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.abilityLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        self.softAbilityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.hardAbilityCollectionView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
    }
    
    private func setWorkDescriptionLayout() {
        self.workDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.softAbilityCollectionView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(18)
        }
        
        self.workDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(self.workDescriptionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}

// swiftlint:enable file_length
