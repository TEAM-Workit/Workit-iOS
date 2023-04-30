//
//  DetailReactor.swift
//  App
//
//  Created by yejiyun-MN on 2023/04/22.
//  Copyright © 2023 com.workit. All rights reserved.
//
import Domain
import Foundation

import ReactorKit

final class DetailReactor: Reactor {
    var initialState: State
    
    enum PreviousView {
        case ability
        case project
    }
    
    struct State {
        var works: [Work]
        var viewType: PreviousView
        var id: Int
        var dateRange: (startDate: Date?, endDate: Date?)
    }
    
    enum Action {
        case loadWorksInProject
        case loadWorksInAbliity
        case setDate(Date?, Date?)
    }
    
    enum Mutation {
        case works([Work])
        case setDate(Date?, Date?)
    }
    
    let projectUseCase: ProjectUseCase
    
    init(projectUseCase: ProjectUseCase, viewType: PreviousView, id: Int) {
        self.projectUseCase = projectUseCase
    
        self.initialState = .init(works: [], viewType: viewType, id: id)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadWorksInProject:
            return self.projectUseCase
                .fetchProjectsDetail(
                    id: currentState.id,
                    startDate: currentState.dateRange.startDate,
                    endDate: currentState.dateRange.endDate
                )
                .map { Mutation.works($0) }
        case .loadWorksInAbliity:
            return .empty()
        case let .setDate(startDate, endDate):
            let date = Observable.just(Mutation.setDate(startDate, endDate))
            if currentState.viewType == .project {
                let works = projectUseCase
                    .fetchProjectsDetail(
                        id: currentState.id,
                        startDate: startDate,
                        endDate: endDate
                    )
                    .map { Mutation.works($0) }
                return Observable.concat(date, works)
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .works(works):
            newState.works = works
        case let .setDate(startDate, endDate):
            newState.dateRange = (startDate, endDate)
        default:
            break
        }
        
        return newState
    }
}
