//
//  ProjectManagementAlertReactor.swift
//  App
//
//  Created by 윤예지 on 2023/03/19.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global
import Foundation
import ReactorKit
import RxSwift

final class ProjectManagementAlertReactor: AlertReactor<ProjectManagementAlertAction> {
    let projectID: Int
    
    init(projectID: Int) {
        self.projectID = projectID
    }
    
    override func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            return .just(Mutation.setActions([.modify, .delete, .cancel]))
        case let .selectAction(alertAction):
            switch alertAction {
            case .modify:
                return .empty()
            case .delete:
                return .empty()
            case .cancel:
                return .empty()
            }
        }
    }
}
