//
//  CalendarBottomSheetTopView.swift
//  App
//
//  Created by 김혜수 on 2023/01/31.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class CalendarBottomSheetTopView: UIView {
    
    fileprivate let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.wkX, for: .normal)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .h3M
        label.textColor = .wkBlack
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkBlack30
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubviews([closeButton, dateLabel, lineView])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        self.closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.lineView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    internal func setDateRange(startDate: Date?, endDate: Date?) {
        guard
            let startDate = startDate,
            let endDate = endDate
        else {
            dateLabel.text = ""
            return
        }
        dateLabel.text = "\(startDate.toString(type: .fullYearDot)) - \(endDate.toString(type: .fullYearDot))"
    }
    
    internal func setSingleDate(date: Date?) {
        guard
            let date = date
        else { return }
        dateLabel.text = String(date.toString(type: .fullYearDot))
    }
}

extension Reactive where Base: CalendarBottomSheetTopView {
    var closeButtonDidTap: ControlEvent<Void> {
        return base.closeButton.rx.tap
    }
}
