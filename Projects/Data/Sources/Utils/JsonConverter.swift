//
//  JsonUtil.swift
//  Data
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

struct JsonConverter {
    static func toJson<T: Decodable>(object: Any) -> T? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: object) {
            let decoder = JSONDecoder()
            let result = try? decoder.decode(T.self, from: jsonData)
            return result
        } else {
            return nil
        }
    }
}
