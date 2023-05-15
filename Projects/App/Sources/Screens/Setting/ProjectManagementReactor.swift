//
//  ProjectCreateReactor.swift
//  App
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import ReactorKit

final class ProjectManagementReactor: Reactor {
    var initialState: State
    
    private let projectUseCase: ProjectUseCase
    
    init(projectUseCase: ProjectUseCase) {
        self.projectUseCase = projectUseCase
        self.initialState = .init(
            newProjectTitle: "",
            projectList: [],
            isEnableCreateButton: false,
            isDuplicatedProject: false
        )
    }
    
    enum Action {
        case viewDidLoad
        case setTitle(String?)
        case createButtonTapped
        case modifyButtonTapped(String?, Int?)
        case deleteButtonTapped(Int?)
        case setNewProjectTitle(String?)
    }
    
    struct State {
        var newProjectTitle: String
        var projectList: [Project]
        var isEnableCreateButton: Bool
        var isDuplicatedProject: Bool
    }
    
    enum Mutation {
        case setTitle(String)
        case createProject(Project?)
        case projects([Project])
        case modifyTitle(String, Int, Int)
        case deleteProject(Int, Int)
        case setNewProjectTitle(String?)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let projects = projectUseCase.fetchProjects()
            return projects.map { Mutation.projects($0) }
            
        case let .setTitle(name):
            guard let name = name else { return .empty() }
            return .just(Mutation.setTitle(name))
            
        case .createButtonTapped:
            if currentState.newProjectTitle.isEmpty {
                return .empty()
            }
            
            return self.projectUseCase
                .createProject(title: currentState.newProjectTitle)
                .map { Mutation.createProject($0) }
                .asObservable()
            
        case let .modifyButtonTapped(projectName, projectID):
            if let projectName = projectName,
               let projectID = projectID {
                return self.projectUseCase
                    .modifyProject(id: projectID, title: projectName)
                    .map { Mutation.modifyTitle(projectName, projectID, $0) }
                    .asObservable()
            } else {
                return .empty()
            }
            
        case let .deleteButtonTapped(projectID):
            guard let projectID = projectID else { return .empty() }
            return self.projectUseCase
                .deleteProject(id: projectID)
                .map { Mutation.deleteProject(projectID, $0) }
                .asObservable()
            
        case let .setNewProjectTitle(title):
            return .just(Mutation.setNewProjectTitle(title))
        }
    }
    
    // swiftlint:disable cyclomatic_complexity
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .projects(projects):
            newState.projectList = projects
            
        case let .setTitle(name):
            newState.newProjectTitle = name
            
        case let .createProject(response):
            guard let project = response else {
                newState.isDuplicatedProject = true
                return newState
            }
            newState.isDuplicatedProject = false
            newState.projectList.insert(project, at: 0)
            
        case let .modifyTitle(name, projectID, statusCode):
            if statusCode == 20000 {
                guard let index = newState.projectList.firstIndex(where: { item in
                    item.id == projectID
                }) else { break }
                
                newState.projectList[index].title = name
            }
            
        case let .deleteProject(projectID, statusCode):
            if statusCode == 20000 {
                guard let index = newState.projectList.firstIndex(where: { item in
                    item.id == projectID
                }) else { break }
                
                newState.projectList.remove(at: index)
            }
            
        case let .setNewProjectTitle(title):
            guard let title = title else { return newState }
            if isOnlyContainsSpacing(newTitle: title) || title.isEmpty {
                newState.isEnableCreateButton = false
                return newState
            }
            newState.isEnableCreateButton = true
        }
        
        return newState
    }
    // swiftlint:enable cyclomatic_complexity
    
    func isOnlyContainsSpacing(newTitle: String) -> Bool {
        let replacedString = newTitle.replacingOccurrences(of: " ", with: "")
        return replacedString.isEmpty
    }
}
