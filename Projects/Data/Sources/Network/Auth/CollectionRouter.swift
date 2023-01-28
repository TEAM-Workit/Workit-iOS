//
//  CollectionRouter.swift
//  Data
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import Global

import Alamofire

public enum CollcetionRouter {
    case fetchProjects
}

extension CollcetionRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .fetchProjects:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .fetchProjects:
            return URLConstant.project + "/collection"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .fetchProjects:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .fetchProjects:
            request = try JSONEncoding.default.encode(request, with: parameters)
        }
      
        return request
    }
}
