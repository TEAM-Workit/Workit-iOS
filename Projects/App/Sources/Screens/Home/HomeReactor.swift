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
            dates: (startDate: Date(), endDate: Date()),
            username: "")
    }
    
    enum Action {
        case viewWillAppear
        case setDate(Date, Date)
    }
    
    struct State {
        var works: [Work]
        var dates: (startDate: Date, endDate: Date)
        var username: String
    }
    
    enum Mutation {
        case setProjects([Work])
        case setName(String)
        case setDate(Date, Date)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            let works = workUseCase.fetchWorksDate(
                start: currentState.dates.startDate,
                end: currentState.dates.endDate)
                .map { Mutation.setProjects($0) }
            let name = userUseCase.fetchUserNickname()
                .map { Mutation.setName($0.nickname) }
            return Observable.concat(works, name)
            
        case .setDate(let startDate, let endDate):
            let date = Observable.just(Mutation.setDate(startDate, endDate))
            let works = workUseCase.fetchWorksDate(
                start: startDate,
                end: endDate)
                .map { Mutation.setProjects($0) }
            return Observable.concat(date, works)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setProjects(let works):
            newState.works = works
        case .setName(let name):
            newState.username = name
        case .setDate(let startDate, let endDate):
            newState.dates = (startDate, endDate)
        }
        
        return newState
    }
}
