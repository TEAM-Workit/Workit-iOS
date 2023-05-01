//
//  String+.swift
//  Global
//
//  Created by 김혜수 on 2023/05/01.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

extension String {
    public func trimmingSpace() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
}
