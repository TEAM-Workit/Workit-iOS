//
//  AuthResponseDTO.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct AuthResponseDTO: Decodable {
    let accessToken: String
    let id: Int
    
    public func toDomain() -> AuthToken {
        return AuthToken.init(accessToken: accessToken, id: id)
    }
}
