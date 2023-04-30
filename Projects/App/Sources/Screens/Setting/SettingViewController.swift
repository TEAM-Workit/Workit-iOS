//
//  SettingViewController.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/24.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Data
import Domain
import DesignSystem
import Global
import UIKit

import ReactorKit
import SnapKit

class SettingViewController: BaseViewController, View {
    
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
        static let logoutTitle = "로그아웃 하시겠습니까?"
        static let cancel = "취소"
        static let confirm = "확인"
    }
    
    public var disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    
    private lazy var dismissButton: UIButton = WKNavigationButton(image: Image.wkX)
    
    private lazy var navigationBar: WKNavigationBar = {
        let navigationBar: WKNavigationBar = WKNavigationBar()
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: self.dismissButton)
        navigationBar.barTintColor = .wkMainPurple
        navigationBar.tintColor = .wkWhite
        dismissButton.addTarget(self, action: #selector(dismissButtonDidTapped), for: .touchUpInside)
        return navigationBar
    }()
    
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
        
        self.setUI()
        self.setNavigationBar()
        self.setTableView()
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar()
    }
    
    // MARK: - Bind (ReactorKit)
    
    func bind(reactor: SettingReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingReactor) {
        self.withdrawButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let withdrawViewController = WithdrawalViewController()
                withdrawViewController.reactor = WithdrawalReactor()
                withdrawViewController.modalPresentationStyle = .fullScreen
                owner.present(withdrawViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map { Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SettingReactor) {
        reactor.state
            .map { $0.userInformation }
            .withUnretained(self)
            .bind { owner, user in
                owner.profileView.setUsername(text: user.nickname)
                owner.profileView.setEmail(text: user.email)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.view.backgroundColor = .wkMainPurple
    }
    
    private func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.isScrollEnabled = false
    }

    override func setLayout() {
        self.view.addSubviews([navigationBar, tableView, profileView, withdrawButton])

        self.navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
       }
        
        self.profileView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
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
        self.navigationController?.isNavigationBarHidden = true
        self.navigationBar.topItem?.title = "설정"
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.wkWhite]
    }
    
    @objc private func dismissButtonDidTapped() {
        self.dismiss(animated: true)
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
            let projectViewController = ProjectManagementViewController()
            let useCase = DefaultProjectUseCase(projectRepository: DefaultProjectRepository())
            projectViewController.reactor = ProjectManagementReactor(projectUseCase: useCase)
            self.navigationController?.pushViewController(projectViewController, animated: true)
            return
        case .service:
            return
        case .inquiry:
            return
        case .policy:
            return
        case .logout:
            let alert = UIAlertController(title: Text.logoutTitle,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Text.cancel, style: .cancel))
            alert.addAction(UIAlertAction(title: Text.confirm, style: .default) { _ in
                UserDefaultsManager.shared.removeToken()
                RootViewChange.shared.setRootViewController(.splash)
            })
            
            self.present(alert, animated: true, completion: nil)
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
