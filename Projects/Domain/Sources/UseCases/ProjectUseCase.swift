//
//  ProjectUseCase.swift
//  Domain
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import RxSwift

public protocol ProjectUseCase {
    func createProject(title: String) -> Observable<Project?>
    func fetchProjects() -> Observable<[Project]>
    func fetchProjectsDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<[Work]>
    func deleteProject(id: Int) -> Observable<Int>
    func modifyProject(id: Int, title: String) -> Observable<Int>
}

public final class DefaultProjectUseCase: ProjectUseCase {
    private let projectRepository: ProjectRepository
    
    public init(projectRepository: ProjectRepository) {
        self.projectRepository = projectRepository
    }

    public func createProject(title: String) -> Observable<Project?> {
        return projectRepository.createProject(title: title)
    }
    
    public func fetchProjects() -> Observable<[Project]> {
        return projectRepository.fetchProjects()
    }
    
    public func fetchProjectsDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<[Work]> {
        return projectRepository.fetchProjectsDetail(id: id, startDate: startDate, endDate: endDate)
    }
    
    public func deleteProject(id: Int) -> Observable<Int> {
        return projectRepository.deleteProject(id: id)
    }
    
    public func modifyProject(id: Int, title: String) -> Observable<Int> {
        let result = projectRepository.modifyProject(id: id, title: title)
        return result
    }
}
