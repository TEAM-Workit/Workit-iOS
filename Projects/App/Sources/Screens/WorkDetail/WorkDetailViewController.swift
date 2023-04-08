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

final class WorkDetailViewController: BaseViewController {
    
    enum Text {
        static let abilityTitle = "역량 태그"
        static let workDescriptionTitle = "업무 내용"
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
        label.textColor = .wkBlack
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
    
    private let abilityLabel: WKStarLabel = {
        let label: WKStarLabel = WKStarLabel()
        label.text = Text.abilityTitle
        return label
    }()
    
    private var hardAbilityCollectionView: WKWriteAbilityCollectionView = WKWriteAbilityCollectionView()
    private var softAbilityCollectionView: WKWriteAbilityCollectionView = WKWriteAbilityCollectionView()
    
    private let workDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = Text.workDescriptionTitle
        return label
    }()
    
    // MARK: Properties
    
    private var dummyWorkData: Work = Work(
        id: 1,
        title: "데일리 지표 확인",
        project: Project(title: "솝텀 워킷 프로젝트"),
        description: "최근 며칠간 리텐션이 지속적으로 떨어진 것을 파악했다.\n\n앱 진입하자마자 보이는 새로운 기능에 대한 홍보 팝업을 보고 앱을 꺼버리는 비율이 늘어난 것 같았다.\n\n팝업 표시 이전과 이번주 리텐션 자료를 비교하기 위해 조회를 해보고 오늘 스크럼에서 이야기를 나눴다.\n\n팀장님이 이 부분에 대해서 마케팅팀과 함께 논의해봐야겠다고 하셔서, 해당 내용에 대해 정리해서 마케팅팀 슬랙에 이슈를 전달했다.",
        date: "2022-11-13T00:00:00.000+00:00",
        abilities: [Ability(id: 1, name: "데이터 분석을 통한 서비스 개선", type: "SOFT"), Ability(id: 2, name: "논리적인 커뮤니케이션 능력", type: "SOFT"), Ability(id: 2, name: "지표 분석을 통한 인사이트 도출", type: "HARD")]
    )
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setData(workData: self.dummyWorkData)
    }
    
    override func setLayout() {
        self.setSubviews()
        self.setBackgroundLayout()
    }
    
    private func setData(workData: Work) {
        self.projectTitleLabel.text = workData.project.title
        self.workTitleLabel.text = workData.title
        self.dateLabel.text = workData.date.toDate(type: .dot)?.toString(type: .dot)
    }
}

// MARK: - UI

extension WorkDetailViewController {
    private func setSubviews() {
        self.view.addSubviews([navigationBar, scrollView])
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews([])
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
}
