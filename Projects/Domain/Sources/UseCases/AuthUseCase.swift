//
//  GetUserTokenUseCase.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import Global

import RxSwift

public protocol AuthUseCase {
    func postSocialLogin(requestValue: PostSocialLoginRequestValue) -> Observable<AuthToken>
}

public final class DefaultAuthUseCase: AuthUseCase {
    
    private let authRepository: AuthRepository
    
    public init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    public func postSocialLogin(requestValue: PostSocialLoginRequestValue) -> Observable<AuthToken> {
        return authRepository.postSocialAuth(
            socialType: requestValue.socialType,
            socialToken: requestValue.socialId,
            nickName: requestValue.nickName)
    }
}

public struct PostSocialLoginRequestValue {
    let socialType: SocialType
    let socialId: String
    let nickName: String?
    
    public init(socialType: SocialType, socialId: String, nickName: String? = nil) {
        self.socialType = socialType
        self.socialId = socialId
        self.nickName = nickName
    }
}
