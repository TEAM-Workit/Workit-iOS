//
//  AuthService.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global

import RxAlamofire
import RxSwift

public protocol AuthService {
    func postSocialAuth(socialType: SocialType, request: AuthRequestDTO) -> Observable<BaseResponseType<AuthResponseDTO>>
}

public final class DefaultAuthService: AuthService {

    public func postSocialAuth(socialType: SocialType, request: AuthRequestDTO) -> Observable<BaseResponseType<AuthResponseDTO>> {
        return RxAlamofire.requestJSON(AuthRouter.postAuth(socialType: socialType, request: request))
            .expectingObject(ofType: BaseResponseType<AuthResponseDTO>.self)
    }
}
