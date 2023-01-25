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
        self.view.addSubview(bottomView)
        
        self.bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(620 + self.bottomView.layer.cornerRadius)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(620 + self.bottomView.layer.cornerRadius)
        }
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
}
