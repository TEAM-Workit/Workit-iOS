//
//  BaseArrayResponseType.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct BaseArrayResponseType<T: Decodable>: Decodable {
    let status: Int
    let message: String?
    let success: Bool?
    let data: [T]?

    var statusCase: StatusCase? {
        return StatusCase(rawValue: status)
    }
}
