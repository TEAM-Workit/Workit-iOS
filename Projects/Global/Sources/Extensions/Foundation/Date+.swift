//
//  Date+.swift
//  Global
//
//  Created by 김혜수 on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Foundation

public enum DateType: String {
    /// yy.MM.dd.
    case dot = "yy.MM.dd."
    /// yy.MM.dd
    case simpleDot = "yy.MM.dd"
    /// yy-MM-dd
    case dash = "yy-MM-dd"
    /// yyyy-MM-dd
    case fullYearDash = "yyyy-MM-dd"
    /// yyyy.MM.dd
    case fullYearDot = "yyyy.MM.dd"
    /// yyyy-MM-dd'T'HH:mm:ss.SSSZ
    case full = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}

extension Date {
    /// Date 타입을 String으로 변환
    public func toString(type: DateType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.string(from: self)
    }
}

extension String {
    /// String 타입을 Date타입으로 변환
    public func toDate(type: DateType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = type.rawValue
        return dateFormatter.date(from: self)
    }
}
