//
//  Ability.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global

public struct Ability {
    public let id: Int
    public let name: String
    public let type: TagType
    
    public init(id: Int, name: String, type: String) {
        self.id = id
        self.name = name
        self.type = TagType(rawValue: type)
    }
}
