//
//  WithdrawalReactor.swift
//  App
//
//  Created by 김혜수 on 2023/04/22.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import ReactorKit

final class WithdrawalReactor: Reactor {
    
    var initialState: State
    
    init() {
        initialState = .init(
            agreeButtonSelected: false,
            isCompletedWithDraw: false)
    }
    
    enum Action {
        case agreeButtonTap
        case withdrawButtonDidTap
    }
    
    struct State {
        var agreeButtonSelected: Bool
        var isCompletedWithDraw: Bool
    }
    
    enum Mutation {
        case changeAgreeButtonState
        case withDraw
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .agreeButtonTap:
            return Observable.just(Mutation.changeAgreeButtonState)
            
        case .withdrawButtonDidTap:
            return Observable.just(Mutation.withDraw)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .changeAgreeButtonState:
            newState.agreeButtonSelected.toggle()

        case .withDraw:
            newState.isCompletedWithDraw = true
        }
        
        return newState
    }
}
