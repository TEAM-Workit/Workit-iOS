//
//  ProjectDeleteAlertAction.swift
//  App
//
//  Created by 윤예지 on 2023/03/19.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

enum ProjectDeleteAlertAction: AlertActionType, CaseIterable {
    case cancel
    case confirm
    
    var title: String {
        switch self {
        case .cancel:
            return "취소"
        case .confirm:
            return "확인"
        }
    }
}
