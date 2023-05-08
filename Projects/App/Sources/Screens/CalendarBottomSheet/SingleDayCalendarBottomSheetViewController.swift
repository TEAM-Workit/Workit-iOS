//
//  SingleDayCalendarBottomSheetViewController.swift
//  App
//
//  Created by madilyn on 2023/04/06.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import HorizonCalendar
import RxSwift
import SnapKit

// swiftlint:disable type_name

protocol SingleDayCalendarBottomSheetDelegate: AnyObject {
    func sendSelectedSingleDay(_ date: Date)
}

final class SingleDayCalendarBottomSheetViewController: BaseViewController {
    
    enum Text {
        static let okMessage = "확인"
        static let reset = "TODAY"
    }
    
    // MARK: - UIComponenets
    
    private let bottomView: UIView = {
        let view: UIView = UIView()
        view.makeRounded(radius: 12)
        view.backgroundColor = .wkWhite
        return view
    }()
    
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
    
    lazy var calendarView = CalendarView(initialContent: makeContent())
    
    // MARK: - Properties
    
    weak var delegate: SingleDayCalendarBottomSheetDelegate?
    
    private let dateSelectPublisher = PublishSubject<(CalendarSelection?)>()
    private let disposeBag = DisposeBag()
    private var selectedDay: Day?
    
    lazy var calendar = Calendar.current
    lazy var dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.locale = calendar.locale
        dateFormatter.dateFormat = DateFormatter.dateFormat(
            fromTemplate: "EEEE, MMM d, yyyy",
            options: 0,
            locale: calendar.locale ?? Locale.current)
        return dateFormatter
    }()
    
    lazy var dayItemClosure: (Day) -> AnyCalendarItemModel = { [weak self, calendar, dayDateFormatter] day in
        
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
        let isSelectedStyle: Bool = day == self?.selectedDay
        
        if isSelectedStyle {
            invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .black
            invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .black
            invariantViewProperties.textColor = .white
        }
        
        invariantViewProperties.font = .b1M
        let date = calendar.date(from: day.components)

        return DayView.calendarItemModel(
            invariantViewProperties: invariantViewProperties,
            viewModel: .init(
                dayText: "\(day.day)",
                accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                accessibilityHint: nil))
    }
    
    lazy var daySelectionClosure: ((Day) -> Void) = {[weak self] calendarDay in
        
        guard let self = self else { return }
        
        self.selectedDay = calendarDay
        self.dateSelectPublisher.onNext(CalendarSelection.singleDay(self.selectedDay ?? calendarDay))
        self.calendarView.setContent(self.makeContent())
    }
    
    // MARK: - Initializer
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setLayout()
        self.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .wkBlack.withAlphaComponent(0.7)
        self.calendarView.daySelectionHandler = daySelectionClosure
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateBottomViewUI()
    }
    
    // MARK: - Methods
    
    private func bind() {
        self.resetButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                let today = owner.calendar.day(containing: Date())
                owner.selectedDay = today
                owner.dateSelectPublisher.onNext(CalendarSelection.singleDay(owner.selectedDay ?? today))
                owner.calendarView.setContent(owner.makeContent())
                owner.calendarView.scroll(
                    toMonthContaining: Date(),
                    scrollPosition: .centered,
                    animated: true)
            }
            .disposed(by: disposeBag)
        
        self.okButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.delegate?.sendSelectedSingleDay(owner.calendar.date(from: owner.selectedDay!.components) ?? Date())
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    internal func setCalenderInitialDate(_ date: Date) {
        let day = calendar.day(containing: date)
        self.selectedDay = day
        self.calendarView.setContent(makeContent())
        
        self.calendarView.scroll(
            toMonthContaining: date,
            scrollPosition: .centered, animated: false)
        self.dateSelectPublisher.onNext(CalendarSelection.singleDay(self.selectedDay ?? day))
    }
    
    func makeContent() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(year: 2010, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2100, month: 12, day: 31))!
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: .horizontal(options: .init()))
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        .monthHeaderItemProvider({ month in
            var invariantViewProperties = MonthHeaderView.InvariantViewProperties.base
            invariantViewProperties.font = .h4B
            return MonthHeaderView.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                viewModel: .init(
                    monthText: "\(month.components.year ?? 0)년 \(month.month)월",
                    accessibilityLabel: nil))
        })
        .dayItemProvider(dayItemClosure)
    }
    
    internal override func setLayout() {
        self.view.addSubviews([bottomView])
        self.bottomView.addSubviews([okButton, resetButton, calendarView])
        
        self.bottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(500 + self.bottomView.layer.cornerRadius)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(500 + self.bottomView.layer.cornerRadius)
        }
        
        self.okButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.width.equalTo(85)
            make.height.equalTo(35)
        }
        
        self.resetButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.okButton)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(24)
        }
        
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.okButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(360)
        }
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

// swiftlint:enable type_name
