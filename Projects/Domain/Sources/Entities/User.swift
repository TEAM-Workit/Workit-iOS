//
//  User.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct User {
    public let nickname: String
    public let email: String
    
    public init(nickname: String, email: String = "") {
        self.nickname = nickname
        self.email = email
    }
}
