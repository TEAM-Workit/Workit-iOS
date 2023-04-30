//
//  AbilityService.swift
//  Data
//
//  Created by madilyn on 2023/04/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Alamofire
import Foundation

import RxAlamofire
import RxSwift

public protocol AbilityService {
    func fetchAllAbility(completion: @escaping (BaseResponseType<AllAbilityResponseDTO>) -> Void)
    func fetchAbilityDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<BaseResponseType<AbilityDetailResponseDTO>>
}

public final class DefaultAbilityService: AbilityService {
    public func fetchAllAbility(completion: @escaping (BaseResponseType<AllAbilityResponseDTO>) -> Void) {
        AF.request(AbilityRouter.fetchAllAbility)
            .responseDecodable(of: BaseResponseType<AllAbilityResponseDTO>.self) { response in
                if let result = response.value {
                    completion(result)
                }
            }
    }
    
    public func fetchAbilityDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<BaseResponseType<AbilityDetailResponseDTO>> {
        return RxAlamofire.requestJSON(AbilityRouter.fetchAbilityDetail(id: id, startDate: startDate, endDate: endDate))
            .expectingObject(ofType: BaseResponseType<AbilityDetailResponseDTO>.self)
    }
}
