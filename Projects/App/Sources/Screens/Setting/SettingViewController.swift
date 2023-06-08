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
import SafariServices
import UIKit

import ReactorKit
import SnapKit
import Mixpanel

class SettingViewController: BaseViewController, View {
    
    enum Setting: Int, CaseIterable {
        case notification
        case project
        case service
        case csv
        case inquiry
        case policy
        case logout
        case appVersion
        
        var title: String {
            switch self {
            case .notification: return "알림 설정"
            case .project: return "프로젝트 관리"
            case .service: return "서비스 소개"
            case .csv: return "파일로 내려받기"
            case .inquiry: return "문의하기"
            case .policy: return "앱 정보"
            case .logout: return "로그아웃"
            case .appVersion: return "현재 버전"
            }
        }
        
        var url: String {
            switch self {
            case .service:
                return "https://workit-team.notion.site/About-Workit-1efde21df0ec4d358a87d1d6acb49801"
            case .inquiry:
                return "https://forms.gle/ZzG7zY1mc7DAZ7ot9"
            case .policy:
                return "https://workit-team.notion.site/Workit-9fd68a7ce34e4b23ad0f20bcd9841569"
            default:
                return ""
            }
        }
    }
    
    enum Text {
        static let withdraw = "탈퇴하기"
        static let logoutTitle = "로그아웃 하시겠습니까?"
        static let cancel = "취소"
        static let confirm = "확인"
        static let preparing = "준비중인 기능입니다."
        static let profileEmptyEmail = "오늘도 열심히 워킷 💜"
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
    
    private var notificationState: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: notificationSettingsCompletionHandler)
    }
    
    // MARK: - Notification oberserver methods
    
    @objc
    func willEnterForeground() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: notificationSettingsCompletionHandler)
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
                withdrawViewController.reactor = WithdrawalReactor(
                    userUseCase: DefaultUserUseCase(
                        userRepository: DefaultUserRepository()))
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
                let nameSuffix = user.email.isEmpty ? "님" : ""
                owner.profileView.setUsername(text: user.nickname + nameSuffix)
                let subTitle = user.email.isEmpty ? Text.profileEmptyEmail : user.email
                owner.profileView.setEmail(text: subTitle)
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
        self.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.wkWhite, .font: UIFont.h3Sb]
    }
    
    @objc private func dismissButtonDidTapped() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func notificationSettingsCompletionHandler(settings: UNNotificationSettings) {
        DispatchQueue.main.async {
            self.notificationState = settings.authorizationStatus == .authorized ? true : false
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let type = Setting(rawValue: indexPath.row) else { return }
        switch type {
        case .notification:
            break
        case .project:
            let projectViewController = ProjectManagementViewController()
            let useCase = DefaultProjectUseCase(projectRepository: DefaultProjectRepository())
            projectViewController.reactor = ProjectManagementReactor(projectUseCase: useCase)
            self.navigationController?.pushViewController(projectViewController, animated: true)
        case .service:
            let url = URL(string: type.url)
            let view: SFSafariViewController = SFSafariViewController(url: url!)
            self.present(view, animated: true, completion: nil)
        case .csv:
            Mixpanel.mainInstance().track(event: "설정_추출버튼_Clicked")
            
            let alert = UIAlertController(title: Text.preparing,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Text.confirm, style: .cancel))
            self.present(alert, animated: true)
        case .inquiry:
            let url = URL(string: type.url)
            let view: SFSafariViewController = SFSafariViewController(url: url!)
            self.present(view, animated: true, completion: nil)
        case .policy:
            let url = URL(string: type.url)
            let view: SFSafariViewController = SFSafariViewController(url: url!)
            self.present(view, animated: true, completion: nil)
        case .logout:
            let alert = UIAlertController(title: Text.logoutTitle,
                                          message: nil,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Text.cancel, style: .cancel))
            alert.addAction(UIAlertAction(title: Text.confirm, style: .default) { _ in
                Mixpanel.mainInstance().track(event: "설정_로그아웃 모달 확인 버튼_Clicked")
                UserDefaultsManager.shared.removeToken()
                RootViewChange.shared.setRootViewController(.splash)
            })
            self.present(alert, animated: true, completion: nil)
        case .appVersion:
            guard
                let url = URL(string: "itms-apps://itunes.apple.com/app/6448702578")
            else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
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
        
        switch Setting.allCases[indexPath.item] {
        case .notification:
            cell.type = .toggle
            cell.toggle.delegate = self
            cell.toggle.isOn = notificationState
        case .appVersion:
            cell.type = .subtitle
            cell.subTitleLabel.text = Bundle.appVersion
        default:
            cell.type = .default
        }
        
        return cell
    }
    
}

extension SettingViewController: WKToggleDelegate {
    func toggleStateChanged(_ toggle: WKToggle, isOn: Bool) {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
