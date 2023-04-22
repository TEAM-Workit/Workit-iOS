//
//  ProjectDeleteAlertReactor.swift
//  App
//
//  Created by 윤예지 on 2023/03/19.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global
import Foundation
import ReactorKit
import RxSwift

final class ProjectDeleteAlertReactor: AlertReactor<ProjectDeleteAlertAction> {
    let projectID: Int
    
    init(projectID: Int) {
        self.projectID = projectID
    }
    
    override func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .prepare:
            return .just(Mutation.setActions([.cancel, .confirm]))
        case let .selectAction(alertAction):
            switch alertAction {
            case .cancel:
                return .empty()
            case .confirm:
                return .empty()
            }
        }
    }
    
}
