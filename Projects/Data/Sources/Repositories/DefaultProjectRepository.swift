//
//  DefaultProjectRepository.swift
//  Data
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Foundation

import RxSwift

public final class DefaultProjectRepository: ProjectRepository {
    public init() { }
    
    public func createProject(title: String) -> Observable<Project?> {
        return NetworkService.shared.project.createProject(request: ProjectRequestDTO.init(title: title))
            .map { $0.data?.toProjectDomain() }
    }
    
    public func createProject(title: String, completion: @escaping (Project) -> Void) {
        let projectRequest: ProjectRequestDTO = ProjectRequestDTO(title: title)
        NetworkService.shared.project.createProject(request: projectRequest) { data in
            if let projectsResponse = data.data {
                completion(projectsResponse.toProjectDomain())
            }
        }
    }
    
    public func fetchProjects() -> Observable<[Project]> {
        return NetworkService.shared.project.fetchProjects()
            .compactMap { $0.data }
            .map { projects in
                return projects.map { $0.toProjectDomain() }
            }
    }
    
    public func fetchProjectsDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<[Work]> {
        return NetworkService.shared.project.fetchProjectsDetail(id: id, startDate: startDate, endDate: endDate)
            .compactMap { $0.data }
            .map { $0.toDomain() }
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
    
    public func fetchRecentProjects(completion: @escaping ([Project]) -> Void) {
        NetworkService.shared.project.fetchRecentProjects { data in
            if let projectsResponse = data.data {
                let projects = projectsResponse.map { project in
                    project.toProjectDomain()
                }
                completion(projects)
            }
        }
    }
}
