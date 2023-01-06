//
//  WKPickDateBottomViewController.swift
//  DesignSystem
//
//  Created by madilyn on 2022/12/06.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit

import SnapKit

public final class WKPickDateBottomViewController: UIViewController {
    
    // MARK: UIComponenets
    
    private let bottomView: UIView = {
        let view: UIView = UIView()
        view.makeRounded(radius: 12)
        view.backgroundColor = .wkWhite
        return view
    }()
    
    private let doneButton: WKRoundedButton = {
        let button: WKRoundedButton = WKRoundedButton()
        button.setEnabledColor(color: .wkMainNavy)
        button.setTitle("확인", for: .normal)
        return button
    }()
    
    // MARK: Initializer
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        self.setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        self.setDoneButtonAction()
        self.setBackgroundViewAction()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBottomViewUI()
    }
    
    // MARK: Methods
    
    private func setBackgroundViewAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapAction(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setDoneButtonAction() {
        self.doneButton.setAction { [weak self] in
            self?.dismiss(animated: true)
    @objc
    func backgroundTapAction(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
        }
    }
}

// MARK: - UI

extension WKPickDateBottomViewController {
    private func setLayout() {
        self.view.addSubview(bottomView)
        
        self.bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(271 + self.bottomView.layer.cornerRadius)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(271 + self.bottomView.layer.cornerRadius)
        }
        
        self.bottomView.addSubview(doneButton)
        
        self.doneButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(85)
            make.height.equalTo(35)
        }
    }
    
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
