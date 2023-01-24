//
//  StatusCase.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

enum StatusCase: Int {
    case okay = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unAuthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case internalServerError = 500
    case serviceUnavailable = 503
    case dbError = 600
}
