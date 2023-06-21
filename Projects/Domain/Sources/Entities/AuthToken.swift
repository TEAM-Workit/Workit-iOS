//
//  AuthToken.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct AuthToken {
    public let accessToken: String
    public let id: Int
    
    public init(accessToken: String, id: Int) {
        self.accessToken = accessToken
        self.id = id
    }
}
