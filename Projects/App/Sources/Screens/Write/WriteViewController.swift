//
//  WriteViewController.swift
//  App
//
//  Created by madilyn on 2022/12/09.
//  Copyright © 2022 com.workit. All rights reserved.
//

import DesignSystem
import Global
import UIKit

import SnapKit

final class WriteViewController: BaseViewController {
    
    // MARK: - UIComponents
    
    private let navigationBar: WKNavigationBar = {
        let navigationBar: WKNavigationBar = WKNavigationBar()
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: WKNavigationButton(text: "저장"))
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: WKNavigationButton(image: Image.wkX))
        return navigationBar
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = UIView()
    
    private let dateLabel: WKStarLabel = {
        let label: WKStarLabel = WKStarLabel()
        label.text = "업무 날짜"
        return label
    }()
    
    private let dateButton: WKTextFieldStyleButton = WKTextFieldStyleButton(style: .withCalendarStyle)
    
    private let projectLabel: WKStarLabel = {
        let label: WKStarLabel = WKStarLabel()
        label.text = "프로젝트"
        return label
    }()
    
    private let projectButton: WKTextFieldStyleButton = {
        let button: WKTextFieldStyleButton = WKTextFieldStyleButton(style: .defaultStyle)
        button.setPlaceholder(text: "프로젝트명을 입력해주세요")
        return button
    }()
    
    private let workLabel: WKStarLabel = {
        let label: WKStarLabel = WKStarLabel()
        label.text = "업무"
        return label
    }()
    
    private let workTextField: WKTextField = {
        let textField: WKTextField = WKTextField()
        textField.placeholder = "업무명을 입력해주세요"
        return textField
    }()
    
    private let abilityLabel: WKStarLabel = {
        let label: WKStarLabel = WKStarLabel()
        label.text = "역량 태그"
        return label
    }()
    
    private let abilityCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    private let abilityAddButton: WKAbilityAddButton = {
        let button: WKAbilityAddButton = WKAbilityAddButton()
        button.setTitle("역량 추가하기", for: .normal)
        return button
    }()
    
    private let workDescriptionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "업무 내용"
        return label
    }()
    
    private let workDescriptionTextView: WKTextView = {
        let textView: WKTextView = WKTextView()
        textView.setPlaceholder(text: "업무의 구체적인 과정과 배운 점을 남겨주세요!")
        return textView
    }()
    
    private let workDescriptionCountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textAlignment = .right
        label.font = .b3Sb
        label.textColor = .wkBlack30
        return label
    }()
    
    // MARK: Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setLabelStyle()
        self.setWorkDescriptionTextView()
    }
    
// MARK: - UI

extension WriteViewController {
    override func setLayout() {
        self.setSubviews()
        self.setBackgroundLayout()
        self.setDateLayout()
        self.setProjectLayout()
        self.setWorkLayout()
        self.setAbilityLayout()
        self.setWorkDescriptionLayout()
    }
    
    private func setSubviews() {
        self.view.addSubviews([navigationBar, scrollView])
        self.contentView.addSubviews([
            dateLabel, dateButton,
            projectLabel, projectButton,
            workLabel, workTextField,
            abilityLabel, abilityCollectionView, abilityAddButton,
            workDescriptionLabel, workDescriptionTextView, workDescriptionCountLabel
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
        
        self.scrollView.addSubview(contentView)
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
    }
    
    private func setDateLayout() {
        self.dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
        }
        
        self.dateButton.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setProjectLayout() {
        self.projectLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.projectButton.snp.makeConstraints { make in
            make.top.equalTo(self.projectLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setWorkLayout() {
        self.workLabel.snp.makeConstraints { make in
            make.top.equalTo(self.projectButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.workTextField.snp.makeConstraints { make in
            make.top.equalTo(self.workLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setAbilityLayout() {
        self.abilityLabel.snp.makeConstraints { make in
            make.top.equalTo(self.workTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.abilityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.abilityLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        self.abilityAddButton.snp.makeConstraints { make in
            make.top.equalTo(self.abilityCollectionView.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(111)
            make.height.equalTo(29)
        }
    }
    
    private func setWorkDescriptionLayout() {
        self.workDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.abilityAddButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(20)
        }
        
        self.workDescriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(self.workDescriptionLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(306)
        }
        
        self.workDescriptionCountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.workDescriptionTextView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(28)
            make.height.equalTo(15)
        }
    }
    
    private func setLabelStyle() {
        [
            self.dateLabel, self.projectLabel, self.workLabel,
            self.abilityLabel, self.abilityLabel, self.workDescriptionLabel
        ].forEach { label in
            label.font = .h4Sb
            label.textColor = .wkBlack
            label.sizeToFit()
        }
    }
}
