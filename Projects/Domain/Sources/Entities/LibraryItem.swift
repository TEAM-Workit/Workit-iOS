//
//  LibraryItem.swift
//  Domain
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

public struct LibraryItem {
    let id: Int
    let name: String
    let count: Int
    
    public init(id: Int, name: String, count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
}
