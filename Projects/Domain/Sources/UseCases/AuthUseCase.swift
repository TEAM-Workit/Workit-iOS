//
//  GetUserTokenUseCase.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import RxSwift

protocol AuthUseCase {
    func postSocialLogin(requestValue: PostSocialLoginRequestValue) -> Observable<AuthToken>
}

final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func postSocialLogin(requestValue: PostSocialLoginRequestValue) -> Observable<AuthToken> {
        return authRepository.postSocialAuth(
            socialType: requestValue.socialType,
            socialToken: requestValue.socialId,
            nickName: requestValue.nickName)
    }
}

struct PostSocialLoginRequestValue {
    let socialType: String
    let socialId: String
    let nickName: String?
}
