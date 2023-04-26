//
//  DefaultProjectRepository.swift
//  Data
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import RxSwift

public final class DefaultProjectRepository: ProjectRepository {
    
    public init() { }
    
    public func createProject(title: String) -> Observable<Project> {
        return NetworkService.shared.project.createProject(request: ProjectRequestDTO.init(title: title))
            .compactMap { $0.data }
            .map { $0.toProjectDomain() }
    }
    
    public func fetchProjects() -> Observable<[Project]> {
        return NetworkService.shared.project.fetchProjects()
            .compactMap { $0.data }
            .map { projects in
                return projects.map { $0.toProjectDomain() }
            }
    }
    
    public func fetchProjects(completion: @escaping ([Project]) -> Void) {
        NetworkService.shared.project.fetchProjects { data in
            if let projectsResponse = data.data {
                let projects = projectsResponse.map { project in
                    project.toProjectDomain()
                }
                completion(projects)
            }
        }
    }
    
    public func deleteProject(id: Int) -> Observable<Int> {
        return NetworkService.shared.project.deleteProject(id: id)
            .compactMap { $0.status }
    }
    
    public func modifyProject(id: Int, title: String) -> Observable<Int> {
        return NetworkService.shared.project.modifyProject(id: id, request: ProjectRequestDTO.init(title: title))
            .compactMap { $0.status }
    }
}
