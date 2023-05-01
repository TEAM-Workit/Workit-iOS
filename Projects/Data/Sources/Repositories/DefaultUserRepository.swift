//
//  DefaultUserRepository.swift
//  Data
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import RxSwift

public final class DefaultUserRepository: UserRepository {
    
    public init() { }
    
    public func fetchUserNickname() -> Observable<User> {
        return NetworkService.shared.user.fetchNickname()
            .compactMap { $0.data }
            .map { $0.toDomain() }
    }
    
    public func fetchUserInformation() -> Observable<User> {
        return NetworkService.shared.user.fetchUserInformation()
            .compactMap { $0.data }
            .map { $0.toDomain() }
    }
}
