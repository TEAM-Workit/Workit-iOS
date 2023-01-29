//
//  WorkService.swift
//  Data
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import RxAlamofire
import RxSwift

public protocol WorkService {
    func fetchWorks() -> Observable<BaseResponseType<WorksResponseDTO>>
}

public final class DefaultWorkService: WorkService {

    public func fetchWorks() -> Observable<BaseResponseType<WorksResponseDTO>> {
        return RxAlamofire.requestJSON(WorkRouter.fetchWorks)
            .expectingObject(ofType: BaseResponseType<WorksResponseDTO>.self)
    }
}
