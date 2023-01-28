//
//  SocialType.swift
//  Global
//
//  Created by 김혜수 on 2023/01/27.
//  Copyright © 2023 com.workit. All rights reserved.
//

public enum SocialType: String {
    case APPLE
    case KAKAO
    
    public init(rawValue: String) {
        switch rawValue {
        case "KAKAO": self = .KAKAO
        case "APPLE": self = .APPLE
        default:
            fatalError("KAKAO, APPLE이 아님")
        }
    }
}
