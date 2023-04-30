//
//  AbilityService.swift
//  Data
//
//  Created by madilyn on 2023/04/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Alamofire
import RxSwift

public protocol AbilityService {
    func fetchAllAbility(completion: @escaping (BaseResponseType<AllAbilityResponseDTO>) -> Void)
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
}
