//
//  WorkDetail.swift
//  Domain
//
//  Created by madilyn on 2023/04/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct WorkDetail: Hashable {
    public let id: Int
    public let title: String
    public let project: Project
    public let description: String
    public let date: String
    public let abilities: [Ability]
  
    public init(
        id: Int,
        title: String,
        project: Project,
        description: String,
        date: String,
        abilities: [Ability]
    ) {
        self.id = id
        self.title = title
        self.project = project
        self.description = description
        self.date = date
        self.abilities = abilities
    }
    
    public static func == (lhs: WorkDetail, rhs: WorkDetail) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
