//
//  UserInformationResponseDTO.swift
//  Data
//
//  Created by yejiyun-MN on 2023/05/01.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct UserInformationResponseDTO: Decodable {
    let nickname: String
    let email: String
    
    func toDomain() -> User {
        return User(nickname: self.nickname, email: self.email)
    }
}
