//
//  ProjectManagementAlertAction.swift
//  App
//
//  Created by 윤예지 on 2023/03/19.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit
import Global

enum ProjectManagementAlertAction: AlertActionType {
    case modify
    case delete
    case cancel
    
    var title: String {
        switch self {
        case .modify: return "수정"
        case .delete: return "삭제"
        case .cancel: return "취소"
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .modify: return .default
        case .delete: return .destructive
        case .cancel: return .cancel
        }
    }
    
}
