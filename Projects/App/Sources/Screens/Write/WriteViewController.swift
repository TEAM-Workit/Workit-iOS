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

// swiftlint:disable file_length

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
    
    private var hardAbilityCollectionView: WKWriteAbilityCollectionView = WKWriteAbilityCollectionView()
    private var softAbilityCollectionView: WKWriteAbilityCollectionView = WKWriteAbilityCollectionView()
    
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
    
    private let hardAbilityFlowLayout: WriteAbilityCollectionViewFlowLayout = WriteAbilityCollectionViewFlowLayout()
    private let softAbilityFlowLayout: WriteAbilityCollectionViewFlowLayout = WriteAbilityCollectionViewFlowLayout()
    
    // MARK: Properties
    
    private var keyboardHeight: CGFloat = 0
    
    private var selectedHardAbilityList: [WriteAbility] = []
    private var selectedSoftAbilityList: [WriteAbility] = []
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setLabelStyle()
        self.setWorkDescriptionTextView()
        self.setAbilityAddButtonAction()
        self.setAbilityCollectionView()
        self.setProjectButtonAction()
        self.setDateButtonAction()
        self.setCloseButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardObserver()
        self.updateAbilityCollectionViewHeight()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.removeKeyboardObserver()
    }
    
    // MARK: Methods
    
    private func setWorkDescriptionTextView() {
        self.workDescriptionTextView.delegate = self
    }
    
    private func setAbilityAddButtonAction() {
        self.abilityAddButton.setAction { [weak self] in
            let bottomViewController: PickAbilityBottomViewController = PickAbilityBottomViewController()
            bottomViewController.delegate = self
            self?.present(bottomViewController, animated: true)
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nibName
        )
    }
    
    @objc
    func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            self.keyboardHeight = keyboardRectangle.height
        }
    }
    
    override func setLayout() {
        self.setSubviews()
        self.setBackgroundLayout()
        self.setDateLayout()
        self.setProjectLayout()
        self.setWorkLayout()
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
    
    private func updateAbilityCollectionViewHeight() {
        self.hardAbilityCollectionView.snp.updateConstraints { make in
            make.top.equalTo(self.abilityLabel.snp.bottom).offset(self.selectedHardAbilityList.isEmpty ? 0 : 8)
            make.height.equalTo(self.selectedHardAbilityList.isEmpty ? 0 : 29)
        }
        self.softAbilityCollectionView.snp.updateConstraints { make in
            make.height.equalTo(self.selectedSoftAbilityList.isEmpty ? 0 : 29)
        }
    }
    
    private func setProjectButtonAction() {
        self.projectButton.setAction { [weak self] in
            let selectProjectBottomViewController: SelectProjectBottomViewController = SelectProjectBottomViewController()
            selectProjectBottomViewController.delegate = self
            self?.present(selectProjectBottomViewController, animated: true)
        }
    }
    
    private func setDateButtonAction() {
        self.dateButton.setAction { [weak self] in
            let dateBottomViewController = SingleDayCalendarBottomSheetViewController()
            dateBottomViewController.modalPresentationStyle = .overFullScreen
            dateBottomViewController.modalTransitionStyle = .crossDissolve
            dateBottomViewController.delegate = self
            
            dateBottomViewController.setCalenderInitialDate(self?.dateButton.date() ?? Date())
            
            self?.present(dateBottomViewController, animated: true)
        }
    }
    
    private func setCloseButtonAction() {
        if let button = self.navigationBar.topItem?.leftBarButtonItem?.customView as? UIButton {
            button.setAction { [weak self] in
                let alert = UIAlertController(
                    title: Text.closeTitle,
                    message: Text.closeContent,
                    preferredStyle: .alert
                )
                let continueAction = UIAlertAction(title: Text.continueTitle, style: .cancel) { _ in
                    alert.dismiss(animated: true)
                }
                let cancelAction = UIAlertAction(title: Text.cancelTitle, style: .destructive) { _ in
                    self?.dismiss(animated: true)
                }
                
                alert.addAction(continueAction)
                alert.addAction(cancelAction)
                
                self?.present(alert, animated: true)
            }
        }
    }
}

// MARK: - Extension (UICollectionViewDelegateFlowLayout)

extension WriteViewController: SingleDayCalendarBottomSheetDelegate {
    func sendSelectedSingleDay(_ date: Date) {
        print(date)
        self.dateButton.setDate(date: date)
    }
}

// MARK: - Extension (SendSelectedAbilityListDelegate)

extension WriteViewController: SendSelectedAbilityListDelegate {
    func sendUpdate(hardAbilityList: [WriteAbility], softAbilityList: [WriteAbility]) {
        self.selectedHardAbilityList = hardAbilityList
        self.selectedSoftAbilityList = softAbilityList
        
        self.updateAbilityCollectionViewHeight()
        
        self.hardAbilityCollectionView.layoutIfNeeded()
        self.softAbilityCollectionView.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.hardAbilityCollectionView.reloadData()
            self.softAbilityCollectionView.reloadData()
        }
    }
}

// MARK: - Extension (SendSelectedAbilityListDelegate)

extension WriteViewController: SendSelectedProjectDelegate {
    func sendUpdate(selectedProjectTitle: String) {
        self.projectButton.setText(text: selectedProjectTitle)
    }
}

extension WriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.hardAbilityCollectionView:
            return self.selectedHardAbilityList.count
        case self.softAbilityCollectionView:
            return self.selectedSoftAbilityList.count
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
            
            cell.setData(data: self.selectedHardAbilityList[indexPath.row])
            
            return cell
        case self.softAbilityCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "softCell",
                for: indexPath
            ) as? WKWriteAbilityCollectionViewCell
            else { return UICollectionViewCell() }
            
            cell.setData(data: self.selectedSoftAbilityList[indexPath.row])
            
            return cell
        default: return UICollectionViewCell()
        }
    }
}

// MARK: - Extension (UICollectionViewDelegateFlowLayout)

extension WriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let sizingCell = WKWriteAbilityCollectionViewCell()
        
        switch collectionViewLayout {
        case self.hardAbilityFlowLayout:
            sizingCell.setData(data: selectedHardAbilityList[indexPath.row])
        case self.softAbilityFlowLayout:
            sizingCell.setData(data: selectedSoftAbilityList[indexPath.row])
        default: return .zero
        }
        
        let cellWidth = sizingCell.titleLabelWidth() + 20
        let cellHeight = 29
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }
}

// MARK: - Extension (UITextViewDelegate)

extension WriteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollView.setContentOffset(
            CGPoint(x: 0, y: self.workDescriptionLabel.frame.minY - 20),
            animated: true
        )
        
        self.scrollView.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(self.keyboardHeight)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.scrollView.snp.updateConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        self.scrollView.setContentOffset(
            CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height),
            animated: true
        )
    }
}

// MARK: - UI

extension WriteViewController {
    private func setSubviews() {
        self.view.addSubviews([navigationBar, scrollView])
        self.scrollView.addSubview(contentView)
        self.contentView.addSubviews([
            dateLabel, dateButton,
            projectLabel, projectButton,
            workLabel, workTextField,
            abilityLabel, hardAbilityCollectionView, softAbilityCollectionView, abilityAddButton,
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
        
        self.abilityAddButton.snp.makeConstraints { make in
            make.top.equalTo(self.softAbilityCollectionView.snp.bottom).offset(8)
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
