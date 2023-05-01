//
//  HTTPError.swift
//  Data
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

enum HTTPError: Int, Error {
    case badRequest = 400
    case notFound = 404
    case conflict = 409
    case internalServerError = 500
    case unknown
}
