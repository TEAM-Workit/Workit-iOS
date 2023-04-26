//
//  DefaultAbilityRepository.swift
//  Data
//
//  Created by madilyn on 2023/04/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

import RxSwift

public final class DefaultAbilityRepository: AbilityRepository {
    
    public init() { }
    
    public func fetchAllAbility(completion: @escaping ([Ability]) -> Void) {
        NetworkService.shared.ability.fetchAllAbility(completion: { data in
            if let allAbilityResponse = data.data {
                completion(allAbilityResponse.toDomain())
            }
        })
    }
}
