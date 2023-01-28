//
//  SettingViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/24.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import SnapKit

class SettingViewController: UIViewController {
    
    enum Setting: Int, CaseIterable {
        case project
        case service
        case inquiry
        case policy
        case logout
        
        var title: String {
            switch self {
            case .project: return "프로젝트 관리"
            case .service: return "서비스 소개"
            case .inquiry: return "문의하기"
            case .policy: return "정책 및 약관"
            case .logout: return "로그아웃"
            }
        }
    }
    
    enum Text {
        static let withdraw = "탈퇴하기"
    }
    
    // MARK: - UIComponents
    
    private let profileView = UserProfileView()
    
    private let withdrawButton: UIButton = {
        let label = UIButton()
        label.setTitle(Text.withdraw, for: .normal)
        label.titleLabel?.font = .b1M
        label.setTitleColor(.wkBlack45, for: .normal)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SettingTableViewCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTableView()
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
    }
    
    // MARK: - Methods
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
    }

    private func setLayout() {
        self.view.addSubviews([profileView, tableView, withdrawButton])

        self.profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(120)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.leading.bottom.trailing.equalToSuperview()
        }
        
        self.withdrawButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-45)
        }
    }

    private func setNavigationBar() {
        self.navigationController?.setNavigationBarApperance(
            backgroundColor: .wkMainPurple,
            tintColor: .wkWhite)
        self.navigationItem.title = "설정"
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Setting(rawValue: indexPath.row) {
        case .project:
            let projectViewController = ProjectCreateViewController()
            self.navigationController?.pushViewController(projectViewController, animated: true)
            return
        case .service:
            return
        case .inquiry:
            return
        case .policy:
            return
        case .logout:
            return
        case .none:
            return
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SettingViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Setting.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setTitle(Setting.allCases[indexPath.item].title)
        cell.selectionStyle = .none
        return cell
    }
    
}
