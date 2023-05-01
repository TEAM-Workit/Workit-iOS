//
//  UserRepository.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import RxSwift

public protocol UserRepository {
    func fetchUserNickname() -> Observable<User>
    func fetchUserInformation() -> Observable<User>
}
