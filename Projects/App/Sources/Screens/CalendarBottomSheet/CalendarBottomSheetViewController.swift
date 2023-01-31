//
//  HomeCalenderBottomSheetViewController.swift
//  App
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import HorizonCalendar
import SnapKit

final class CalendarBottomSheetViewController: BaseViewController {
    
    enum Text {
        static let okMessage = "확인"
        static let reset = "초기화"
    }
    
    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkWhite
        view.makeRounded(radius: 12)
        return view
    }()
    
    private let topView = CalendarBottomSheetTopView()
    
    lazy var calendarView = CalendarView(initialContent: makeContent())
    
    private let okButton: WKRoundedButton = {
        let button = WKRoundedButton()
        button.setTitle(Text.okMessage, for: .normal)
        button.setEnabledColor(color: .wkMainNavy)
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.reset, for: .normal)
        button.setImage(Image.wkReset, for: .normal)
        button.setTitleColor(.wkBlack, for: .normal)
        button.titleLabel?.font = .b1M
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .wkBlack30
    }
    
    private func makeContent() -> CalendarViewContent {
      let calendar = Calendar.current

      let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
      let endDate = calendar.date(from: DateComponents(year: 2021, month: 12, day: 31))!

      return CalendarViewContent(
        calendar: calendar,
        visibleDateRange: startDate...endDate,
        monthsLayout: .horizontal(options: HorizontalMonthsLayoutOptions(
            scrollingBehavior: .paginatedScrolling(
                .init(
                    restingPosition: .atIncrementsOfCalendarWidth,
                    restingAffinity: .atPositionsAdjacentToPrevious)))))
    }
    
    internal override func setLayout() {
        self.view.addSubviews([bottomBackgroundView])
        bottomBackgroundView.addSubviews([topView, calendarView, resetButton, okButton])
        
        self.bottomBackgroundView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(500)
        }
        
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(345)
        }
        
        self.resetButton.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(20)
            make.width.equalTo(63)
            make.height.equalTo(24)
        }
        
        self.okButton.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom).offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(85)
            make.height.equalTo(35)
        }
    }
}
