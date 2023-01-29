//
//  UserNicknameResponseDTO.swift
//  Data
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct UserNicknameResponseDTO: Decodable {
    let nickname: String
    
    func toDomain() -> User {
        return User(nickname: self.nickname)
    }
}
