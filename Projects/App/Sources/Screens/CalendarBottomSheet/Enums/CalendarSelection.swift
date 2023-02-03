//
//  CalendarSelection.swift
//  App
//
//  Created by 김혜수 on 2023/02/02.
//  Copyright © 2023 com.workit. All rights reserved.
//

import HorizonCalendar

enum CalendarSelection {
    case singleDay(Day)
    case dayRange(DayRange)
}
