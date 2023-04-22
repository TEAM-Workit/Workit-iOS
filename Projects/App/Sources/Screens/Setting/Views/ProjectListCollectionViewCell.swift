//
//  ProjectListCollectionViewCell.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import DesignSystem
import UIKit

import SnapKit
import RxSwift
import RxCocoa

@objc
protocol DeleteButtonDelegate: AnyObject {
    @objc optional func deleteButtonTapped(_ button: UIButton, projectID: Int)
}

class ProjectListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    
    private let projectTitleView: UILabel = {
        let label = UILabel()
        label.font = .b1M
        label.textColor = .wkBlack65
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack15
        return view
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.wkKebapB, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    weak var delegate: DeleteButtonDelegate?
    var disposeBag = DisposeBag()
    private var project: Project = Project(title: "")
    
    // MARK: - Initializer
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setLayout() {
        self.addSubviews([projectTitleView, editButton, separatorView])
        
        self.projectTitleView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview()
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
        }
        
        self.editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.separatorView.snp.makeConstraints { make in
            make.top.equalTo(projectTitleView.snp.bottom).offset(22)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setTitle(_ text: String) {
        self.projectTitleView.text = text
    }
    
    func setProject(_ project: Project) {
        self.project = project
    }
    
    @objc
    private func deleteButtonTapped(sender: UIButton) {
        delegate?.deleteButtonTapped!(sender, projectID: self.project.id)
    }
}

class RxCollectionViewCellDelegateProxy: DelegateProxy<ProjectListCollectionViewCell, DeleteButtonDelegate>, DelegateProxyType, DeleteButtonDelegate {
    
    static func registerKnownImplementations() {
        self.register { button in
            RxCollectionViewCellDelegateProxy(parentObject: button,
                                              delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: ProjectListCollectionViewCell) -> DeleteButtonDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: DeleteButtonDelegate?, to object: ProjectListCollectionViewCell) {
        object.delegate = delegate
    }
        
}

extension Reactive where Base: ProjectListCollectionViewCell {
    var delegate: DelegateProxy<ProjectListCollectionViewCell, DeleteButtonDelegate> {
        return RxCollectionViewCellDelegateProxy.proxy(for: self.base)
    }
    
    var deleteButtonDelegate: Observable<Int> {
        return delegate
            .methodInvoked(#selector(DeleteButtonDelegate.deleteButtonTapped(_:projectID:)))
            .map({ parameters in
                print(parameters)
                return parameters[1] as? Int ?? 0
            })
    }
}
