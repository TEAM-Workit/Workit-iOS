//
//  HomeReactor.swift
//  App
//
//  Created by 김혜수 on 2022/11/07.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Domain
import Foundation.NSDate

import ReactorKit

final class HomeReactor: Reactor {
    
    var initialState: State
    
    private let workUseCase: WorkUseCase
    private let userUseCase: UserUseCase
    
    init(
        workUseCase: WorkUseCase,
        userUseCase: UserUseCase
    ) {
        self.workUseCase = workUseCase
        self.userUseCase = userUseCase
        initialState = .init(
            works: [],
            startDate: Date(),
            endDate: Date(),
            username: "")
    }
    
    enum Action {
        case viewWillAppear
    }
    
    struct State {
        var works: [Work]
        var startDate: Date
        var endDate: Date
        var username: String
    }
    
    enum Mutation {
        case setProjects([Work])
        case setName(String)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            // TODO: BottomSheet 연결 후 currentState로 변경
            let works = workUseCase.fetchWorksDate(
                start: "2023.01.28".toDate(type: .fullYearDash) ?? .now,
                end: currentState.endDate)
                .map { Mutation.setProjects($0) }
            let name = userUseCase.fetchUserNickname()
                .map { Mutation.setName($0.nickname) }
            return Observable.concat(works, name)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProjects(let works):
            newState.works = works
        case .setName(let name):
            newState.username = name
        }
        
        return newState
    }
}
