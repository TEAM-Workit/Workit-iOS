//
//  WKDateButton.swift
//  DesignSystem
//
//  Created by 김혜수 on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Global
import UIKit

import RxSwift
import SnapKit

/**
 - 사용시 가로길이, 세로길이(32)는 지정되어 있으므로 위치만 잡아주면 됩니다.
 */
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
    
    public private(set) var fromDate: Date?
    public private(set) var toDate: Date?
    fileprivate let tapPublisher = PublishSubject<()>()
    
    // MARK: - Initializer

    /// - Parameters:
    ///    - fromDate: 시작날짜 (형식: YY.MM.DD.)
    ///    - toDate: 끝나는 날짜 (형식: YY.MM.DD. / 단일 날짜의 경우 nil)
    public init(fromDate: Date? = nil, toDate: Date? = nil) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
        setGesture()
        setDate(fromDate: fromDate, toDate: toDate)
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
        
        self.snp.makeConstraints { make in
            make.height.equalTo(32)
        }
    }

    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.addGestureRecognizer(tapGesture)
        self.isUserInteractionEnabled = true
    }

    /// 컴포넌트 생성 후 Date를 다시 설정하는 함수
    /// - Parameters:
    ///    - fromDate: 시작날짜 (날짜 선택 전일 경우 nil)
    ///    - toDate: 끝나는 날짜 (단일 날짜의 경우 nil)
    public func setDate(fromDate: Date?, toDate: Date?) {
        self.fromDate = fromDate
        self.toDate = toDate
        var date = "" + "\(fromDate?.toString(type: .dot) ?? "날짜 선택")"
        if let toDate = toDate?.toString(type: .dot) {
            date += " - \(toDate)"
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
