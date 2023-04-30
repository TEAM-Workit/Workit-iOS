//
//  AbilityRouter.swift
//  Data
//
//  Created by madilyn on 2023/04/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import Alamofire

public enum AbilityRouter {
    /// 전체 역량 조회
    case fetchAllAbility
}

extension AbilityRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .fetchAllAbility:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchAllAbility:
            return URLConstant.ability
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchAllAbility:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .fetchAllAbility:
           break
        }
      
        return request
    }
}
