//
//  AbilityDetail.swift
//  Domain
//
//  Created by yejiyun-MN on 2023/04/30.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

public struct AbilityDetail {
    public let abilityName: String
    public let works: [Work]
    
    public init(abilityName: String, works: [Work]) {
        self.abilityName = abilityName
        self.works = works
    }
}
