//
//  AuthRequestDTO.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct AuthRequestDTO: Encodable {
    let socialToken: String
    let nickName: String?
    
    public init(socialToken: String, nickName: String?) {
        self.socialToken = socialToken
        self.nickName = nickName
    }
}

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
