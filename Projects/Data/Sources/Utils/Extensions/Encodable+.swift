//
//  Encodable+.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

extension Encodable {
    var toDictionary: [String: Any] {
        guard let object = try? JSONEncoder().encode(self) else { fatalError() }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any] else { fatalError() }
        return dictionary
    }
}
