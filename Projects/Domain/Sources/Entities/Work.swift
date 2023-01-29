//
//  Work.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct Work: Hashable {
    public let id: Int
    public let title: String
    public let project: Project
    public let description: String
    public let date: String
    public let abilities: [Ability]
    
    public var firstAbilityTag: Ability? {
        get {
            return abilities.first
        }
    }
    
    public var etcAbilityCount: Int {
        get {
            return abilities.count - 1
        }
    }
  
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
    
    public static func == (lhs: Work, rhs: Work) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
