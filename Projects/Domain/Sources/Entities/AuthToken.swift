//
//  AuthToken.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct AuthToken {
    let accessToken: String
    
    public init(accessToken: String) {
        self.accessToken = accessToken
    }
}
