//
//  WKDateButton.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

public final class WKDateButton: UIView {
    
    enum Number {
        static let radius: CGFloat = 16
        static let borderWidth: CGFloat = 1
    }
    
    // MARK: - UIComponents
    
    private let calenderIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.wkCalendar
        return imageView
    }()
    
    private let arrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.wkArrowSmall
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.b3M
        label.textColor = UIColor.wkBlack45
        return label
    }()
    
    // MARK: - Properties
    
    fileprivate let tapPublisher = PublishSubject<()>()
    
    // MARK: - Initializer

    /// - Parameters:
    ///    - from: 시작날짜 (형식: YY.MM.DD.)
    ///    - to: 끝나는 날짜 (형식: YY.MM.DD. / 단일 날짜의 경우 nil)
    public init(from: String? = nil, to: String? = nil) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setGesture()
        setDate(from: from, to: to)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc
    private func viewDidTap() {
        tapPublisher.onNext(())
    }
    
    // MARK: - Methods
    
    private func setUI() {
        self.makeRounded(radius: Number.radius)
        self.layer.borderWidth = Number.borderWidth
        self.layer.borderColor = UIColor.wkBlack15.cgColor
    }
    
    private func setLayout() {
        self.addSubviews([calenderIconImageView, arrowIconImageView, dateLabel])
        
        calenderIconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        arrowIconImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(calenderIconImageView.snp.trailing).offset(6)
            make.trailing.equalTo(arrowIconImageView.snp.leading).offset(-6)
            make.height.equalTo(15)
        }
    }

    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }

    /// 컴포넌트 생성 후 Date를 다시 설정하는 함수
    /// - Parameters:
    ///    - from: 시작날짜 (형식: YY.MM.DD.)
    ///    - to: 끝나는 날짜 (형식: YY.MM.DD. / 단일 날짜의 경우 nil)
    public func setDate(from: String?, to: String?) {
        var date = "" + "\(from ?? "")"
        if let to = to {
            date += " - \(to)"
        }
        dateLabel.text = date
        dateLabel.sizeToFit()
    }
}

// MARK: - Extension (Reactive)

public extension Reactive where Base: WKDateButton {
    var tap: PublishSubject<()> {
        return base.tapPublisher
    }
}
