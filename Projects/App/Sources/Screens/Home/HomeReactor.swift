//
//  HomeReactor.swift
//  App
//
//  Created by 김혜수 on 2022/11/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Domain

import ReactorKit

final class HomeReactor: Reactor {
    
    var initialState: State
    
    private let workUseCase: WorkUseCase
    
    init(workUseCase: DefaultWorkUseCase) {
        self.workUseCase = workUseCase
        initialState = .init(works: [])
    }
    
    enum Action {
        case viewWillAppear
    }
    
    struct State {
        var works: [Work]
    }
    
    enum Mutation {
        case setProjects([Work])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return workUseCase.fetchWorks()
                .map { Mutation.setProjects($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProjects(let works):
            newState.works = works
        }
        
        return newState
    }
}
