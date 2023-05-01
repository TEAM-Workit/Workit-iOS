//
//  UserService.swift
//  Data
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import RxAlamofire
import RxSwift

public protocol UserService {
    func fetchNickname() -> Observable<BaseResponseType<UserNicknameResponseDTO>>
    func fetchUserInformation() -> Observable<BaseResponseType<UserInformationResponseDTO>>
}

public final class DefaultUserService: UserService {
    
    public func fetchNickname() -> Observable<BaseResponseType<UserNicknameResponseDTO>> {
        return RxAlamofire.requestJSON(UserRouter.fetchNickname)
            .expectingObject(ofType: BaseResponseType<UserNicknameResponseDTO>.self)
    }
    
    public func fetchUserInformation() -> Observable<BaseResponseType<UserInformationResponseDTO>> {
        return RxAlamofire.requestJSON(UserRouter.fetchUserInformation)
            .expectingObject(ofType: BaseResponseType<UserInformationResponseDTO>.self)
    }
}
