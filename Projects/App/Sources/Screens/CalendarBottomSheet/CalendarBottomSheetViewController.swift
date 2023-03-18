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

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length

protocol CalendarBottomSheetDelegate: AnyObject {
    func sendSelectedDate(start: Date, end: Date)
}

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
    
    weak var delegate: CalendarBottomSheetDelegate?
    
    private let dateSelectPublisher = PublishSubject<(CalendarSelection?)>()
    private let disposeBag = DisposeBag()
    private var calendarSelection: CalendarSelection?
    
    private var selectedDate: Date = Date()
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
        /// 각 날짜들의 겉모습을 결정해줌
        var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
        let isSelectedStyle: Bool
        
        switch self?.calendarSelection {
        case .singleDay(let selectedDay):
            self?.selectedDate = calendar.date(from: selectedDay.components) ?? Date()
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
        self.selectedDate = self.calendar.date(from: calendarDay.components) ?? Date()
        
        switch self.calendarSelection {
        case .singleDay(let selectedDay):
            /// selectedDay -> 이미 선택되어있던 날짜
            /// 새로 선택한 날짜 (calendarDay)가 이미 선택된 날짜보다 나중이면 Range형태로, 아니면 Single형태로
            /// 이 파일의 calendarSelecteion 프로퍼티에 저장한다.
            if calendarDay > selectedDay {
                self.calendarSelection = .dayRange(selectedDay...calendarDay)
            } else {
                self.calendarSelection = .singleDay(calendarDay)
            }
        case .none, .dayRange:
            /// 만약 아무것도 선택되어 있지 않았거나, 이미 기간이 설정된 상태라면
            /// 다시 새로운 날짜를 선택했을 때 (calendarDay) 단일 날짜 형태로 선택되도록 한다.
            self.calendarSelection = .singleDay(calendarDay)
        }
        self.dateSelectPublisher.onNext(self.calendarSelection)
        /// dayItemClosure 다시 불러짐
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
        self.calendarView.scroll(
            toMonthContaining: self.selectedDate,
            scrollPosition: .centered, animated: false)
        self.topView.setSingleDate(date: self.selectedDate)
    }
    
    // MARK: - Methods
    
    private func bind() {
        self.topView.rx.closeButtonDidTap
            .withUnretained(self)
            .bind { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.dateSelectPublisher
            .bind { [weak self] calendarSelection in
                switch calendarSelection {
                case .dayRange(let range):
                    self?.topView.setDateRange(
                        startDate: self?.calendar.date(from: range.lowerBound.components),
                        endDate: self?.calendar.date(from: range.upperBound.components))
                case .singleDay(let day):
                    self?.topView.setSingleDate(date: self?.calendar.date(from: day.components))
                case .none:
                    self?.topView.setSingleDate(date: self?.selectedDate)
                }
            }
            .disposed(by: disposeBag)
        
        self.resetButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.selectedDate = Date()
                owner.calendarSelection = .none
                owner.dateSelectPublisher.onNext(owner.calendarSelection)
                owner.calendarView.setContent(owner.makeContent())
                owner.calendarView.scroll(
                    toMonthContaining: owner.selectedDate,
                    scrollPosition: .centered,
                    animated: true)
            }
            .disposed(by: disposeBag)
        
        self.okButton.rx.tap
            .withUnretained(self)
            .bind { owner, _ in
                switch owner.calendarSelection {
                case .singleDay(let day):
                    owner.delegate?.sendSelectedDate(
                        start: owner.calendar.date(from: day.components) ?? Date(),
                        end: owner.calendar.date(from: day.components) ?? Date())
                case .dayRange(let range):
                    owner.delegate?.sendSelectedDate(
                        start: owner.calendar.date(from: range.lowerBound.components) ?? Date(),
                        end: owner.calendar.date(from: range.upperBound.components) ?? Date())
                case .none:
                    owner.delegate?.sendSelectedDate(
                        start: Date(),
                        end: Date())
                }
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    internal func setCalenderInitialDate(fromDate: Date, toDate: Date) {
        if fromDate.toString(type: .dot) == toDate.toString(type: .dot) {
            self.selectedDate = fromDate
        } else {
            let range = DayRange(
                containing: ClosedRange(uncheckedBounds: (fromDate, toDate)),
                in: calendar)
            self.calendarSelection = .dayRange(range)
        }
        self.dateSelectPublisher.onNext(self.calendarSelection)
    }
    
    func makeContent() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(year: 2010, month: 01, day: 01))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
        let calendarSelection = self.calendarSelection
        
        var dateRanges: Set<ClosedRange<Date>> = self.dateRanges
        
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
        self.bottomBackgroundView.addSubviews([topView, calendarView, resetButton, okButton])
        
        self.bottomBackgroundView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(540)
        }
        
        self.topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.topView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(360)
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
