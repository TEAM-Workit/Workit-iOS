//
//  Date+.swift
//  Global
//
//  Created by 김혜수 on 2022/11/28.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Foundation

public extension Date {
    /// Date 타입을 String (yy.MM.DD.)으로 변환
    func toYYMMDDString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd."
        return dateFormatter.string(from: self)
    }
}
