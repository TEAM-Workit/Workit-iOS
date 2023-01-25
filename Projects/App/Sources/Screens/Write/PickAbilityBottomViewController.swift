//
//  PickAbilityBottomViewController.swift
//  App
//
//  Created by madilyn on 2023/01/10.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import SnapKit
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
        tableView.rowHeight = 30
        tableView.separatorStyle = .none
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
        tableView.rowHeight = 30
        tableView.separatorStyle = .none
        return tableView
    }()
    
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
        self.setBackgroundViewAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBottomViewUI()
    }
    
    // MARK: Methods
    
    override func setLayout() {
        self.setBottomViewLayout()
        self.setTitleLayout()
        self.setSelectAbilityLayout()
    }
    
    private func setBackgroundViewAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapAction(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func backgroundTapAction(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
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
}
