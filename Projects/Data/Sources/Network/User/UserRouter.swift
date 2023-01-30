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
}

extension UserRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .fetchNickname:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchNickname:
            return URLConstant.user + "/nickname"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchNickname:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .fetchNickname:
           break
        }
      
        return request
    }
}
