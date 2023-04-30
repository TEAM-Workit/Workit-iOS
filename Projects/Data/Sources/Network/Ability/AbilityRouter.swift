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
    case fetchAbilityDetail(id: Int, startDate: Date?, endDate: Date?)
}

extension AbilityRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .fetchAllAbility:
            return .get
        case .fetchAbilityDetail:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchAllAbility:
            return URLConstant.ability
        case let .fetchAbilityDetail(id, startDate, endDate):
            if startDate != nil && endDate != nil {
                return URLConstant.ability + "/\(id)/collection/date"
            }
            return URLConstant.ability + "/\(id)/collection"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .fetchAllAbility:
            return nil
        case let .fetchAbilityDetail(_, startDate, endDate):
            if let startDate = startDate,
               let endDate = endDate {
                return ["start": startDate.toString(type: .fullYearDash),
                        "end": endDate.toString(type: .fullYearDash)]
            }
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
        case let .fetchAbilityDetail(_, startDate, endDate):
            if startDate != nil && endDate != nil {
                request = try URLEncoding.queryString.encode(request, with: parameters)
            }
        }
      
        return request
    }
}
