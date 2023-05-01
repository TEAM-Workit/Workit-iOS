//
//  UserUseCase.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import RxSwift

public protocol UserUseCase {
    func fetchUserNickname() -> Observable<User>
    func fetchUserInformation() -> Observable<User>
    func deleteUser(description: String) -> Observable<Bool>
}

public final class DefaultUserUseCase: UserUseCase {
    
    private let userRepository: UserRepository
    
    public init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    public func fetchUserNickname() -> Observable<User> {
        return userRepository.fetchUserNickname()
    }
    
    public func fetchUserInformation() -> Observable<User> {
        return userRepository.fetchUserInformation()
    }
    
    public func deleteUser(description: String) -> Observable<Bool> {
        return userRepository.deleteUser(description: description)
    }
}
