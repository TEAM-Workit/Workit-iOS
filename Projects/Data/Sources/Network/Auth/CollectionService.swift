//
//  CollectionService.swift
//  Data
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global

import RxAlamofire
import RxSwift

public protocol CollectionService {
    func fetchProjects() -> Observable<BaseResponseType<[ProjectResponseDTO]>>
    func fetchAbilites() -> Observable<BaseResponseType<[AbilityResponseDTO]>>
}

public final class DefaultCollectionService: CollectionService {
    public func fetchAbilites() -> RxSwift.Observable<BaseResponseType<[AbilityResponseDTO]>> {
        return RxAlamofire.requestJSON(CollectionRouter.fetchAbilites)
            .expectingObject(ofType: BaseResponseType<[AbilityResponseDTO]>.self)
    }
    
    public func fetchProjects() -> RxSwift.Observable<BaseResponseType<[ProjectResponseDTO]>> {
        return RxAlamofire.requestJSON(CollectionRouter.fetchProjects)
            .expectingObject(ofType: BaseResponseType<[ProjectResponseDTO]>.self)
    }
}
