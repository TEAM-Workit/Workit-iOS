//
//  DefaultAuthRepository.swift
//  Data
//
//  Created by 김혜수 on 2023/01/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import RxSwift

final class DefaultAuthRepository: AuthRepository {
    func postSocialAuth(socialType: String, socialToken: String, nickName: String?) -> Observable<AuthToken> {
        let requestDTO: AuthRequestDTO = AuthRequestDTO(socialToken: socialToken, nickName: nickName)
        let socialType: SocialType = SocialType(rawValue: socialType)
        return NetworkService.shared.auth.postSocialAuth(socialType: socialType, request: requestDTO)
            .compactMap { $0.data }
            .map { $0.toDomain() }
    }
}
