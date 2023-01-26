//
//  AuthRepository.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

import RxSwift

public protocol AuthRepository {
    func postSocialAuth(socialType: String, socialToken: String, nickName: String?) -> Observable<AuthToken>
}
