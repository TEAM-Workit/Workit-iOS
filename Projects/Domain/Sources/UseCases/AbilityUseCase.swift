//
//  AbilityUseCase.swift
//  Domain
//
//  Created by yejiyun-MN on 2023/05/01.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import RxSwift

public protocol AbilityUseCase {
    func fetchAbilityDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<AbilityDetail>
}

public class DefaultAbilityUseCase: AbilityUseCase {
    private let abilityRepository: AbilityRepository
    
    public init(abilityRepository: AbilityRepository) {
        self.abilityRepository = abilityRepository
    }
    
    public func fetchAbilityDetail(id: Int, startDate: Date?, endDate: Date?) -> RxSwift.Observable<AbilityDetail> {
        return abilityRepository.fetchAbilityDetail(id: id, startDate: startDate, endDate: endDate)
    }
}
