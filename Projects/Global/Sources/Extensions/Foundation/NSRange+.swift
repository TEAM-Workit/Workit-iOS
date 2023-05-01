//
//  NSRange+.swift
//  Global
//
//  Created by 김혜수 on 2023/05/01.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

extension NSRange {
    public func checkTargetWordSelectedRange(contain index: Int) -> Bool {
        return index > location && index < location + length
    }
}
