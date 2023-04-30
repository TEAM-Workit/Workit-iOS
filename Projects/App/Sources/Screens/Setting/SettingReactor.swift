//
//  SettingReactor.swift
//  App
//
//  Created by yejiyun-MN on 2023/05/01.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import ReactorKit

final class SettingReactor: Reactor {
    var initialState: State
    
    private let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        
        self.initialState = .init(userInformation: User(nickname: ""))
    }
    
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        var userInformation: User
    }
    
    enum Mutation {
        case setUserInformation(User)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return userUseCase.fetchUserInformation()
                .map { Mutation.setUserInformation($0) }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setUserInformation(userInformation):
            newState.userInformation = userInformation
        }
        
        return newState
    }
}
