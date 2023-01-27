//
//  DefaultAuthRepository.swift
//  Data
//
//  Created by 김혜수 on 2023/01/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Global

import RxSwift

public final class DefaultAuthRepository: AuthRepository {
    
    public init() { }
    
    public func postSocialAuth(socialType: SocialType, socialToken: String, nickName: String?) -> Observable<AuthToken> {
        let requestDTO: AuthRequestDTO = AuthRequestDTO(socialToken: socialToken, nickName: nickName)
        return NetworkService.shared.auth.postSocialAuth(socialType: socialType, request: requestDTO)
            .compactMap { $0.data }
            .map { $0.toDomain() }
    }
}
