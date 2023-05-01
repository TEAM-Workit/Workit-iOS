//
//  UserRouter.swift
//  Data
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import Alamofire

public enum UserRouter {
    /// 유저 이름 조회
    case fetchNickname
    case fetchUserInformation
    /// 유저 탈퇴
    case deleteUser(description: String)
}

extension UserRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .fetchNickname:
            return .get
        case .fetchUserInformation:
            return .get
        case .deleteUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchNickname:
            return URLConstant.user + "/nickname"
        case .fetchUserInformation:
            return URLConstant.user
        case .deleteUser:
            return URLConstant.user
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchNickname, .fetchUserInformation:
            return nil
        case .deleteUser(let description):
            return ["description": description]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .fetchNickname, .fetchUserInformation:
           break
        case .deleteUser:
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
      
        return request
    }
}
