//
//  Project.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct Project: Hashable {
    public var id: Int
    public var title: String
    
    public init(id: Int = -1, title: String) {
        self.id = id
        self.title = title
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
}
