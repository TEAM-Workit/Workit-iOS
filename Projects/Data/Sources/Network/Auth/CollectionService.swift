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
    func fetchProjects() -> Observable<BaseResponseType<CollectionResponseDTO>>
}

public final class DefaultCollectionService: CollectionService {
    public func fetchProjects() -> RxSwift.Observable<BaseResponseType<CollectionResponseDTO>> {
        return RxAlamofire.requestJSON(CollcetionRouter.fetchProjects)
            .expectingObject(ofType: BaseResponseType<CollectionResponseDTO>.self)
    }
}
