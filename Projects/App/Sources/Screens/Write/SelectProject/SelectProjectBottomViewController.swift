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

final class SelectProjectBottomViewController: BaseViewController {
    
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
    
    private let doneButton: WKRoundedButton = {
        let button: WKRoundedButton = WKRoundedButton()
        button.setEnabledColor(color: .wkMainNavy)
        button.setTitle("선택 완료", for: .normal)
        return button
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
        self.setCloseButtonAction()
        self.setDoneButtonAction()
        self.setDoneButtonEnabled()
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
    }
    
    private func setCloseButtonAction() {
        self.closeButton.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setDoneButtonAction() {
        self.doneButton.setAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    
    private func setDoneButtonEnabled() {
    private func setProjectTextFeild() {
        self.projectTextField.delegate = self
        self.projectTextField.setClearButtonAction { [weak self] in
            self?.projectTextField.isEntered = false
            self?.recentProjectCollectionView.reloadData()
            self?.setDoneButtonEnabled()
        }
    }
    }
    
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
            projectTextField
        ])
        
        self.projectTextField.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
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
}
