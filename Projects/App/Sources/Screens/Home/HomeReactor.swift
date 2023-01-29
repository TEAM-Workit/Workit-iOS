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
    
    init(workUseCase: DefaultWorkUseCase) {
        self.workUseCase = workUseCase
        initialState = .init(
            works: [],
            startDate: Date(),
            endDate: Date())
    }
    
    enum Action {
        case viewWillAppear
    }
    
    struct State {
        var works: [Work]
        var startDate: Date
        var endDate: Date
    }
    
    enum Mutation {
        case setProjects([Work])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            // TODO: BottomSheet 연결 후 currentState로 변경
            return workUseCase.fetchWorksDate(
                start: "2023.01.28".toDate(type: .fullYearDash) ?? .now,
                end: currentState.endDate)
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
