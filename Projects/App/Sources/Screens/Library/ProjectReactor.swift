//
//  ProjectReactor.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import ReactorKit

final class ProjectReactor: Reactor {
    
    var initialState: State
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        var projects: [LibraryItem]
    }
    
    enum Mutation {
        case projects([LibraryItem])
    }
    
    let libraryUseCase: CollectionUseCase
    
    init(libraryUseCase: CollectionUseCase) {
        self.libraryUseCase = libraryUseCase
        
        self.initialState = .init(projects: [])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let projects = libraryUseCase.projects()
            return projects.map { Mutation.projects($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .projects(project):
            newState.projects = project
            return newState
        }
    }

}
