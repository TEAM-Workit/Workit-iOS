//
//  ProjectRepository.swift
//  Domain
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectRepository {
    func createProject(title: String) -> Observable<Project>
    func createProject(title: String, completion: @escaping (Project) -> Void)
    func fetchProjects() -> Observable<[Project]>
    func fetchProjects(completion: @escaping ([Project]) -> Void)
    func deleteProject(id: Int) -> Observable<Int>
    func modifyProject(id: Int, title: String) -> Observable<Int>
    func fetchRecentProjects(completion: @escaping ([Project]) -> Void)
}
