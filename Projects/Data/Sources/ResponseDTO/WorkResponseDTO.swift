//
//  WorkitResponseDTO.swift
//  Data
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct WorksResponseDTO: Decodable {
    let works: [WorkDTO]
    
    public func toDomain() -> [Work] {
        return self.works.map { element in
            
            let project = Project.init(title: element.projectTitle)
            let abilities = element.abilityInfos.map { $0.toDomain() }
            
            return Work.init(
                id: element.workId,
                title: element.workTitle,
                project: project,
                description: element.description,
                date: element.date,
                abilities: abilities)
        }
    }
}

public struct WorkDTO: Decodable {
    let workId: Int
    let projectTitle: String
    let date: String
    let workTitle: String
    let description: String
    let abilityInfos: [AbilityDTO]
}

public struct AbilityDTO: Decodable {
    let abilityId: Int
    let abilityName: String
    let abilityType: String
    
    public func toDomain() -> Ability {
        return Ability.init(
            id: self.abilityId,
            name: self.abilityName,
            type: self.abilityType)
    }
}
