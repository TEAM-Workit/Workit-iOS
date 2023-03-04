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
import RxSwift
import SnapKit

final class CalendarBottomSheetViewController: BaseViewController {
    
    enum Text {
        static let okMessage = "확인"
        static let reset = "초기화"
    }
    
    // MARK: - UIComponenets
    
    private let bottomBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .wkWhite
        view.makeRounded(radius: 12)
        return view
    }()
    
    private let topView = CalendarBottomSheetTopView()
    
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
    
    private let dateSelectPublisher = PublishSubject<(CalendarSelection?)>()
    private let disposeBag = DisposeBag()
    private var calendarSelection: CalendarSelection?
    
    private var selectedDate: Date?
    private var dateRanges: Set<ClosedRange<Date>> = []
    
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
        let isSelectedStyle: Bool
        
        switch self?.calendarSelection {
        case .singleDay(let selectedDay):
            self?.selectedDate = calendar.date(from: selectedDay.components)
            isSelectedStyle = (day == selectedDay)
            
        case .dayRange(let selectedDayRange):
            isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
        case .none:
            isSelectedStyle = false
        }
        
        if isSelectedStyle {
            invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .black
            invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .black
            invariantViewProperties.textColor = .white
        }
        
        invariantViewProperties.font = .b1M
        let date = calendar.date(from: day.components)
        let selectedDate = self?.selectedDate
        if selectedDate?.toString(type: .dot) == date?.toString(type: .dot) {
            invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .black
            invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .black
            invariantViewProperties.textColor = .white
        }
        return DayView.calendarItemModel(
            invariantViewProperties: invariantViewProperties,
            viewModel: .init(
                dayText: "\(day.day)",
                accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                accessibilityHint: nil))
    }
    
    lazy var daySelectionClosure: ((Day) -> Void) = {[weak self] calendarDay in
        
        guard let self = self else { return }
        self.selectedDate = self.calendar.date(from: calendarDay.components)
        
        switch self.calendarSelection {
        case .singleDay(let selectedDay):
            if calendarDay > selectedDay {
                self.calendarSelection = .dayRange(selectedDay...calendarDay)
            } else {
                self.calendarSelection = .singleDay(calendarDay)
            }
        case .none, .dayRange:
            self.calendarSelection = .singleDay(calendarDay)
        }
        self.dateSelectPublisher.onNext(self.calendarSelection)
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
        
        self.view.backgroundColor = .wkBlack30
        self.calendarView.daySelectionHandler = daySelectionClosure
        self.selectedDate = Date()
        self.calendarView.scroll(
            toMonthContaining: self.selectedDate ?? Date(),
            scrollPosition: .centered, animated: false)
        
    }
    
    // MARK: - Methods
    
    private func bind() {
        topView.rx.closeButtonDidTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        dateSelectPublisher
            .bind { [weak self] calendarSelection in
                switch calendarSelection {
                case .dayRange(let range):
                    self?.topView.setDateRange(
                        startDate: self?.calendar.date(from: range.lowerBound.components),
                        endDate: self?.calendar.date(from: range.upperBound.components))
                case .singleDay(let day):
                    self?.topView.setSingleDate(date: self?.calendar.date(from: day.components))
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.selectedDate = Date()
                owner.dateRanges = []
                owner.calendarView.setContent(owner.makeContent())
            }
            .disposed(by: disposeBag)
    }
    
    func makeContent() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(year: 2020, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
        let calendarSelection = self.calendarSelection
        
        var dateRanges: Set<ClosedRange<Date>> = self.dateRanges
        print(dateRanges)
        
        if case .dayRange(let dayRange) = calendarSelection,
           let lowerBound = calendar.date(from: dayRange.lowerBound.components),
           let upperBound = calendar.date(from: dayRange.upperBound.components) {
            dateRanges = [lowerBound...upperBound]
        } else {
            dateRanges = []
        }
        
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
        .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
            return DayRangeIndicatorView.calendarItemModel(
                invariantViewProperties: .init(),
                viewModel: .init(
                    framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
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

// MARK: - Extension

extension CalendarItemViewRepresentable {
    public static func calendarItemModel(
        invariantViewProperties: InvariantViewProperties,
        viewModel: ViewModel
    ) -> CalendarItemModel<Self> {
        CalendarItemModel<Self>(invariantViewProperties: invariantViewProperties, viewModel: viewModel)
    }
}
