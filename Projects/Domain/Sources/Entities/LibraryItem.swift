//
//  LibraryItem.swift
//  Domain
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

public struct LibraryItem: Hashable {
    public let id: Int
    public let name: String
    public let count: Int
    
    public init(id: Int, name: String, count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(count)
    }
}
