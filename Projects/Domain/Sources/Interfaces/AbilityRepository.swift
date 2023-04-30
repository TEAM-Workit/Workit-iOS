//
//  AbilityRepository.swift
//  Domain
//
//  Created by madilyn on 2023/04/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import RxSwift

public protocol AbilityRepository {
    func fetchAllAbility(completion: @escaping ([Ability]) -> Void)
    func fetchAbilityDetail(id: Int, startDate: Date?, endDate: Date?) -> Observable<AbilityDetail>
}
