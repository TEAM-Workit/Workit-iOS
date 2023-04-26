//
//  PickAbilityBottomViewController.swift
//  App
//
//  Created by madilyn on 2023/01/10.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Data
import Domain
import DesignSystem
import Global
import UIKit

import SnapKit

// swiftlint:disable file_length

// MARK: - Protocols
protocol SendSelectedAbilityListDelegate: AnyObject {
    func sendUpdate(
        hardAbilityList: [Ability],
        softAbilityList: [Ability]
    )
}

final class PickAbilityBottomViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let bottomView: UIView = {
        let view: UIView = UIView()
        view.makeRounded(radius: 12)
        view.backgroundColor = .wkWhite
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "역량 태그"
        label.font = .h3Sb
        label.textColor = .wkBlack
        label.textAlignment = .center
        return label
    }()
    
    private let titleBottomLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .wkBlack30
        return view
    }()
    
    private let closeButton: UIButton = {
        let button: UIButton = UIButton(type: .system)
        button.setImage(Image.wkX.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    private let hardAbilityLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "하드 스킬"
        label.font = .h4Sb
        label.textColor = .wkBlack
        return label
    }()
    
    private let hardAbilityTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.rowHeight = 39
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    private let softAbilityLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "소프트 스킬"
        label.font = .h4Sb
        label.textColor = .wkBlack
        return label
    }()
    
    private let softAbilityTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.rowHeight = 39
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        return tableView
    }()
    
    private let doneButton: WKRoundedButton = {
        let button: WKRoundedButton = WKRoundedButton()
        button.setEnabledColor(color: .wkMainNavy)
        button.setTitle("선택 완료", for: .normal)
        return button
    }()
    
    private let hardWhiteBlurView: UIView = UIView()
    private let softWhiteBlurView: UIView = UIView()
    
    // MARK: Properties
    
    private var hardAbilityList: [Ability] = []
    private var softAbilityList: [Ability] = []
    
    private var selectedHardAbilityList: [Ability] = []
    private var selectedSoftAbilityList: [Ability] = []
    
    private let hardCellReuseIdentifier: String = "hardCell"
    private let softCellReuseIdentifier: String = "softCell"
    
    weak var delegate: SendSelectedAbilityListDelegate?
    private let abilityRepository: AbilityRepository = DefaultAbilityRepository()
    
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
        self.setTableView()
        self.setDoneButtonEnabled()
        self.fetchAllAbility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBottomViewUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setWhiteBlurGradient()
    }
    
    // MARK: Methods
    
    override func setLayout() {
        self.setBottomViewLayout()
        self.setTitleLayout()
        self.setSelectAbilityLayout()
        self.setDoneButtonLayout()
        self.setWhiteBlurViewLayout()
    }
    
    private func setCloseButtonAction() {
        self.closeButton.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setDoneButtonAction() {
        self.doneButton.setAction { [weak self] in
            self?.delegate?.sendUpdate(
                hardAbilityList: self?.selectedHardAbilityList ?? [],
                softAbilityList: self?.selectedSoftAbilityList ?? []
            )
            self?.dismiss(animated: true)
        }
    }
    
    private func setTableView() {
        self.hardAbilityTableView.delegate = self
        self.hardAbilityTableView.dataSource = self
        self.softAbilityTableView.delegate = self
        self.softAbilityTableView.dataSource = self
        
        self.hardAbilityTableView.register(
            cell: SelectAbilityTableViewCell.self,
            forCellReuseIdentifier: self.hardCellReuseIdentifier
        )
        self.softAbilityTableView.register(
            cell: SelectAbilityTableViewCell.self,
            forCellReuseIdentifier: self.softCellReuseIdentifier
        )
    }
    
    private func setDoneButtonEnabled() {
        self.doneButton.isEnabled = !self.selectedHardAbilityList.isEmpty || !self.selectedSoftAbilityList.isEmpty
    }
    
    private func setWhiteBlurGradient() {
        self.hardWhiteBlurView.isUserInteractionEnabled = false
        self.softWhiteBlurView.isUserInteractionEnabled = false
        
        self.hardWhiteBlurView.setGradient(
            firstColor: .wkWhite.withAlphaComponent(0),
            secondColor: .wkWhite
        )
        
        self.softWhiteBlurView.setGradient(
            firstColor: .wkWhite.withAlphaComponent(0),
            secondColor: .wkWhite
        )
    }
    
    func setSelectedAbilityList(abilityList: [Ability]) {
        // TODO: 리스폰스에 있는 ability id를 보고 구현...
    }
}

// MARK: - Extension (UITableViewDataSource)
extension PickAbilityBottomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hardAbilityTableView {
            return hardAbilityList.count
        } else {
            return softAbilityList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hardAbilityTableView {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: self.hardCellReuseIdentifier
            ) as? SelectAbilityTableViewCell
            else { return UITableViewCell() }
            
            cell.setData(
                data: self.hardAbilityList[indexPath.row],
                isHard: true
            )
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: self.softCellReuseIdentifier
            ) as? SelectAbilityTableViewCell
            else { return UITableViewCell() }
            
            cell.setData(
                data: self.softAbilityList[indexPath.row],
                isHard: false
            )
            
            return cell
        }
    }
}

// MARK: - Extension (UITableViewDelegate)
extension PickAbilityBottomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SelectAbilityTableViewCell {
            cell.isSelected = true
        }
        if tableView == self.hardAbilityTableView {
            self.selectedHardAbilityList.append(hardAbilityList[indexPath.row])
        } else {
            self.selectedSoftAbilityList.append(softAbilityList[indexPath.row])
        }
        self.setDoneButtonEnabled()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? SelectAbilityTableViewCell {
            cell.isSelected = false
            
            var selectedAbility: Ability = Ability(
                id: 0,
                name: "",
                type: ""
            )
            if tableView == self.hardAbilityTableView {
                selectedAbility = hardAbilityList[indexPath.row]
                
                if let selectedIndex = selectedHardAbilityList.firstIndex(
                    where: { $0.id == selectedAbility.id }
                ) {
                    self.selectedHardAbilityList.remove(at: selectedIndex)
                }
            } else {
                selectedAbility = softAbilityList[indexPath.row]
                
                if let selectedIndex = selectedSoftAbilityList.firstIndex(
                    where: { $0.id == selectedAbility.id }
                ) {
                    self.selectedSoftAbilityList.remove(at: selectedIndex)
                }
            }

        }
        self.setDoneButtonEnabled()
    }
}

// MARK: - UI

extension PickAbilityBottomViewController {
    
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
        self.bottomView.addSubviews([titleLabel, titleBottomLineView, closeButton])
        
        self.titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(17)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.titleBottomLineView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.titleLabel)
            make.trailing.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
    }
    
    private func setSelectAbilityLayout() {
        self.bottomView.addSubviews([hardAbilityLabel, hardAbilityTableView, softAbilityLabel, softAbilityTableView])
        
        self.hardAbilityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleBottomLineView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.hardAbilityTableView.snp.makeConstraints { make in
            make.top.equalTo(self.hardAbilityLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
        
        self.softAbilityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.hardAbilityTableView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        self.softAbilityTableView.snp.makeConstraints { make in
            make.top.equalTo(self.softAbilityLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(150)
        }
    }
    
    private func setDoneButtonLayout() {
        self.bottomView.addSubview(doneButton)
        
        self.doneButton.snp.makeConstraints { make in
            make.top.equalTo(self.softAbilityTableView.snp.bottom).offset(58)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
    
    private func setWhiteBlurViewLayout() {
        self.bottomView.addSubviews([hardWhiteBlurView, softWhiteBlurView])
        
        self.hardWhiteBlurView.snp.makeConstraints { make in
            make.bottom.equalTo(self.hardAbilityTableView).offset(6)
            make.leading.trailing.equalTo(self.hardAbilityTableView)
            make.height.equalTo(self.hardAbilityTableView.snp.height).multipliedBy(0.2)
        }
        
        self.softWhiteBlurView.snp.makeConstraints { make in
            make.bottom.equalTo(self.softAbilityTableView).offset(6)
            make.leading.trailing.equalTo(self.softAbilityTableView)
            make.height.equalTo(self.softAbilityTableView.snp.height).multipliedBy(0.2)
        }
    }
}

// MARK: - Network

extension PickAbilityBottomViewController {
    private func fetchAllAbility() {
        self.softAbilityList = []
        self.hardAbilityList = []
        
        self.abilityRepository.fetchAllAbility(completion: { ability in
            _ = ability.map {
                switch $0.type {
                case .hard:
                    self.hardAbilityList.append($0)
                case .soft:
                    self.softAbilityList.append($0)
                }
                self.hardAbilityTableView.reloadData()
                self.softAbilityTableView.reloadData()
            }
        })
    }
}
