//
//  SelectProjectBottomViewController.swift
//  App
//
//  Created by madilyn on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import SnapKit

// swiftlint:disable file_length

// MARK: - Protocols

protocol SendSelectedProjectDelegate: AnyObject {
    func sendUpdate(selectedProjectTitle: String)
}

final class SelectProjectBottomViewController: BaseViewController {
    
    enum Section: CaseIterable {
        case project
    }
    
    // MARK: - UIComponents
    
    private let bottomView: UIView = {
        let view: UIView = UIView()
        view.makeRounded(radius: 12)
        view.backgroundColor = .wkWhite
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "프로젝트"
        label.font = .h3Sb
        label.textColor = .wkBlack
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(Image.wkX.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let projectTextField: WKProjectSearchTextField = {
        let textField: WKProjectSearchTextField = WKProjectSearchTextField()
        textField.placeholder = "프로젝트 생성 또는 검색 (최대 20자)"
        return textField
    }()
    
    private let recentProjectLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "최근 프로젝트"
        label.font = .b3Sb
        label.textColor = .wkBlack45
        label.sizeToFit()
        return label
    }()
    
    private let searchProjectTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.separatorInset = .zero
        tableView.makeRounded(radius: 5)
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.wkBlack30.cgColor
        tableView.rowHeight = 44
        tableView.register(cell: SearchProjectTableViewCell.self)
        return tableView
    }()
    
    private let recentProjectCollectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.layoutMargins = .zero
        collectionView.collectionViewLayout = WriteLeftAlignedCollectionViewFlowLayout()
        return collectionView
    }()
    
    private let doneButton: WKRoundedButton = {
        let button: WKRoundedButton = WKRoundedButton()
        button.setEnabledColor(color: .wkMainNavy)
        button.setTitle("선택 완료", for: .normal)
        return button
    }()
    
    // MARK: Properties
    
    private var recentProjectList: [RecentProject] = [
        RecentProject(id: 0, title: "카카카카카카카카카카카카카카카카카카카카"),
        RecentProject(id: 1, title: "어쩌구 프로젝트"),
        RecentProject(id: 2, title: "솝텀 프로젝트"),
        RecentProject(id: 3, title: "워킷"),
        RecentProject(id: 4, title: "어쩌구 프로젝트"),
        RecentProject(id: 5, title: "솝텀 프로젝트"),
        RecentProject(id: 6, title: "워킷")
    ]
    
    private var allProjectList: [SearchProjectTableViewCellModel] = [
        SearchProjectTableViewCellModel(id: 0, title: "카카카카카카카카카카카카카카카카카카카카"),
        SearchProjectTableViewCellModel(id: 1, title: "어쩌구 프로젝트"),
        SearchProjectTableViewCellModel(id: 2, title: "솝텀 프로젝트"),
        SearchProjectTableViewCellModel(id: 3, title: "워킷"),
        SearchProjectTableViewCellModel(id: 4, title: "어쩌구 프로젝트"),
        SearchProjectTableViewCellModel(id: 5, title: "솝텀 프로젝트"),
        SearchProjectTableViewCellModel(id: 6, title: "워킷"),
        SearchProjectTableViewCellModel(id: 7, title: "워킷프로젝트"),
        SearchProjectTableViewCellModel(id: 8, title: "뮤멘트"),
        SearchProjectTableViewCellModel(id: 9, title: "플젝"),
        SearchProjectTableViewCellModel(id: 10, title: "프로젝트"),
        SearchProjectTableViewCellModel(id: 11, title: "워킷프로젝트"),
        SearchProjectTableViewCellModel(id: 12, title: "뮤멘트")
    ]
    
    weak var delegate: SendSelectedProjectDelegate?
    var searchProjectDataSource: UITableViewDiffableDataSource<Section, SearchProjectTableViewCellModel>!
    var searchProjectSnapshot: NSDiffableDataSourceSnapshot<Section, SearchProjectTableViewCellModel>!
    
    // MARK: Initializer
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setCloseButtonAction()
        self.setDoneButtonAction()
        self.setRecentProjectCollectionView()
        self.setDoneButtonEnabled()
        self.setSearchProjectTableView()
        self.setProjectTextFeild()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBottomViewUI()
    }
    
    // MARK: Methods
    
    override func setLayout() {
        self.setBottomViewLayout()
        self.setTitleLayout()
        self.setProjectLayout()
        self.setDoneButtonLayout()
        self.setSerachProjectTableViewLayout()
    }
    
    private func setCloseButtonAction() {
        self.closeButton.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setDoneButtonAction() {
        self.doneButton.setAction { [weak self] in
            if let title = self?.projectTextField.text as? String {
                self?.delegate?.sendUpdate(selectedProjectTitle: title)
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func setRecentProjectCollectionView() {
        self.recentProjectCollectionView.delegate = self
        self.recentProjectCollectionView.dataSource = self
        
        self.recentProjectCollectionView.register(cell: WKWriteRecentProjectCollectionViewCell.self)
    }
    
    private func setDoneButtonEnabled() {
        self.doneButton.isEnabled = self.projectTextField.isEntered
    }
    
    func setSelectedAbilityList(abilityList: [WriteAbility]) {
        // TODO: 리스폰스에 있는 ability id를 보고 구현...
    }
    
    private func setProjectTextFeild() {
        self.projectTextField.delegate = self
        self.projectTextField.setClearButtonAction { [weak self] in
            self?.projectTextField.isEntered = false
            self?.recentProjectCollectionView.reloadData()
            self?.setDoneButtonEnabled()
        }
    private func setSearchProjectTableView() {
        self.searchProjectTableView.delegate = self
        self.searchProjectDataSource = UITableViewDiffableDataSource<Section, SearchProjectTableViewCellModel>(
            tableView: self.searchProjectTableView,
            cellProvider: { tableView, indexPath, _ in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchProjectTableViewCell.className,
                    for: indexPath
                ) as? SearchProjectTableViewCell else { return UITableViewCell() }
                cell.setData(data: self.filteredProjectList[indexPath.row])
                if self.filteredProjectList[indexPath.row].id == -1 {
                    cell.setCreateUI()
                } else {
                    cell.setUI()
                }
                return cell
            })
        self.searchProjectDataSource.defaultRowAnimation = .fade
        self.searchProjectTableView.dataSource = self.searchProjectDataSource
    }
    }
}

// MARK: - Extension (UICollectionViewDataSource)

extension SelectProjectBottomViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentProjectList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WKWriteRecentProjectCollectionViewCell.className,
            for: indexPath
        ) as? WKWriteRecentProjectCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setData(data: self.recentProjectList[indexPath.row])
        
        return cell
    }
}

// MARK: - Extension (UICollectionViewDelegateFlowLayout)

extension SelectProjectBottomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizingCell = WKWriteRecentProjectCollectionViewCell()
        sizingCell.setData(data: self.recentProjectList[indexPath.row])
        
        let cellWidth = sizingCell.titleLabelWidth() + 24
        let cellHeight = 29
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.projectTextField.endEditing(true)
        self.projectTextField.text = self.recentProjectList[indexPath.row].title
        self.projectTextField.isEntered = true
        self.setDoneButtonEnabled()
    }
}

// MARK: - Extension (UITextFieldDelegate)

extension SelectProjectBottomViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.projectTextField.isEntered = false
        self.setDoneButtonEnabled()
        self.recentProjectCollectionView.reloadData()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = self.projectTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: string)
        return changedText.count <= 20
    }
}

// MARK: - UI

extension SelectProjectBottomViewController {
    
    private func setUI() {
        self.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.view.backgroundColor = UIColor.wkBlack80
    }
    
    private func updateBottomViewUI() {
        self.bottomView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().offset(self.bottomView.layer.cornerRadius)
        }
        
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.view.layoutIfNeeded()
            })
    }
    
    private func setBottomViewLayout() {
        self.view.addSubview(bottomView)
        
        self.bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(620 + self.bottomView.layer.cornerRadius)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(620 + self.bottomView.layer.cornerRadius)
        }
    }
    
    private func setTitleLayout() {
        self.bottomView.addSubviews([titleLabel, closeButton])
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(17)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
    }
    
    private func setProjectLayout() {
        self.bottomView.addSubviews([
            projectTextField,
            recentProjectLabel,
            recentProjectCollectionView
        ])
        
        self.projectTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        self.recentProjectLabel.snp.makeConstraints { make in
            make.top.equalTo(self.projectTextField.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.recentProjectCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.recentProjectLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
    }
    
    private func setDoneButtonLayout() {
        self.bottomView.addSubview(doneButton)
        
        self.doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.bottom).inset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
    
    private func setSerachProjectTableViewLayout() {
        self.bottomView.addSubview(searchProjectTableView)
        
        self.searchProjectTableView.snp.makeConstraints { make in
            make.top.equalTo(self.projectTextField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self.projectTextField)
            make.height.equalTo(44)
        }
    }
}
