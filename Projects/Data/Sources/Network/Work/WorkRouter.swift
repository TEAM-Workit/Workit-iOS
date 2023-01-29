//
//  WorkRouter.swift
//  Data
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import Alamofire

public enum WorkRouter {
    case fetchWorks
}

extension WorkRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .fetchWorks:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchWorks:
            return URLConstant.work
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchWorks:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .fetchWorks:
           break
        }
      
        return request
    }
}
