//
//  AbilityReactor.swift
//  App
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import ReactorKit

final class AbilityReactor: Reactor {
    
    var initialState: State = .init()
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        var abilities: [LibraryItem] = []
    }
    
    enum Mutation {
        case abilities([LibraryItem])
    }
    
    let libraryUseCase: CollectionUseCase
    
    init(libraryUseCase: CollectionUseCase) {
        self.libraryUseCase = libraryUseCase
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            let projects = libraryUseCase.abilities()
            return projects.map { Mutation.abilities($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .abilities(abilites):
            newState.abilities = abilites
            return newState
        }
    }

}
