//
//  ProjectRouter.swift
//  Data
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import Global

import Alamofire

public enum ProjectRouter {
    case createProject(request: ProjectRequestDTO)
    case fetchProjects
    case fetchProjectsDetail(projectId: Int, startDate: Date?, endDate: Date?)
    case deleteProject(projectId: Int)
    case modifyProject(projectId: Int, request: ProjectRequestDTO)
    case fetchRecentProjects
}

extension ProjectRouter: BaseRequestConvertible {
    
    var method: HTTPMethod {
        switch self {
        case .createProject:
            return .post
        case .fetchProjects, .fetchRecentProjects:
            return .get
        case .fetchProjectsDetail:
            return .get
        case .deleteProject:
            return .delete
        case .modifyProject:
            return .patch
        }
    }
    
    var path: String {
        switch self {
        case .createProject:
            return URLConstant.project
        case .fetchProjects:
            return URLConstant.project + "/all"
        case let .fetchProjectsDetail(projectId, startDate, endDate):
            if let startDate = startDate,
               let endDate = endDate {
                return URLConstant.project + "/\(projectId)" + "/collection/date"
            }
            return URLConstant.project + "/\(projectId)" + "/collection"
        case let .deleteProject(projectId):
            return URLConstant.project + "/\(projectId)"
        case let .modifyProject(projectId, _):
            return URLConstant.project + "/\(projectId)"
        case .fetchRecentProjects:
            return URLConstant.project + "/recent"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case let .createProject(request), let .modifyProject(_, request):
            return request.toDictionary
        case let .fetchProjectsDetail(_, startDate, endDate):
            if let startDate = startDate,
               let endDate = endDate {
                return ["start": startDate.toString(type: .fullYearDash),
                        "end": endDate.toString(type: .fullYearDash)]
            }
            return nil
        default:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        var request = URLRequest(url: url)
        request.method = method
        request.headers = HTTPHeaders(headers)
        
        switch self {
        case .createProject, .modifyProject:
            request = try JSONEncoding.default.encode(request, with: parameters)
        case let .fetchProjectsDetail(_, startDate, endDate):
            if startDate != nil && endDate != nil {
                request = try URLEncoding.queryString.encode(request, with: parameters)
            }
        default:
            break
        }
      
        return request
    }
}
