//
//  ProjectService.swift
//  Data
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global

import Foundation
import RxAlamofire
import RxSwift
import Alamofire
import Dispatch

public protocol ProjectService {
    func createProject(request: ProjectRequestDTO) -> Observable<BaseResponseType<ProjectResponseDTO>>
    func fetchProjects() -> Observable<BaseResponseType<[ProjectResponseDTO]>>
    func fetchProjects(completion: @escaping (BaseResponseType<[ProjectResponseDTO]>) -> Void)
    func deleteProject(id: Int) -> Observable<BaseResponseType<Int>>
    func modifyProject(id: Int, request: ProjectRequestDTO) -> Observable<BaseResponseType<ProjectResponseDTO>>
}

public final class DefaultProjectService: ProjectService {
    public func createProject(request: ProjectRequestDTO) -> Observable<BaseResponseType<ProjectResponseDTO>> {
        return RxAlamofire.requestDecodable(ProjectRouter.createProject(request: request))
            .map { (_, data) in
                return data
            }
            .catch { error in
                return Observable.error(error)
            }
    }
    
    public func fetchProjects() -> Observable<BaseResponseType<[ProjectResponseDTO]>> {
        return RxAlamofire.requestJSON(ProjectRouter.fetchProjects)
            .expectingObject(ofType: BaseResponseType<[ProjectResponseDTO]>.self)
    }
    
    public func fetchProjects(completion: @escaping (BaseResponseType<[ProjectResponseDTO]>) -> Void) {
        AF.request(ProjectRouter.fetchProjects)
            .responseDecodable(of: BaseResponseType<[ProjectResponseDTO]>.self) { response in
                if let result = response.value {
                    completion(result)
                }
            }
    }
    
    public func deleteProject(id: Int) -> Observable<BaseResponseType<Int>> {
        return RxAlamofire.requestJSON(ProjectRouter.deleteProject(projectId: id))
            .expectingObject(ofType: BaseResponseType<Int>.self)
    }
    
    public func modifyProject(id: Int, request: ProjectRequestDTO) -> Observable<BaseResponseType<ProjectResponseDTO>> {
        return RxAlamofire.requestDecodable(ProjectRouter.modifyProject(projectId: id, request: request))
            .map { (_, data) in
                return data
            }.catch { error in
                return Observable.error(error)
            }
    }
}
