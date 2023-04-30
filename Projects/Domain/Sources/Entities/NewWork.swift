//
//  NewWork.swift
//  Domain
//
//  Created by madilyn on 2023/04/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

public struct NewWork {
    public let title: String
    public let projectId: Int
    public let description: String
    public let date: Date
    public let abilityIds: [Int]
    
    public init(title: String, projectId: Int, description: String, date: Date, abilityIds: [Int]) {
        self.title = title
        self.projectId = projectId
        self.description = description
        self.date = date
        self.abilityIds = abilityIds
    }
}
