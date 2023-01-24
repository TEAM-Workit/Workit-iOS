//
//  AuthRouter.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import Alamofire

public enum AuthRouter {
    case postAuth(socialType: SocialType, request: AuthRequestDTO)
}

extension AuthRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .postAuth:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case let .postAuth(socialType, _):
            return URLConstant.auth + "/login/\(socialType)"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .postAuth(_, request):
            return request.toDictionary
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .postAuth:
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
        
        return request
    }
}

