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
    
}
