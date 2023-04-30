//
//  AbilityDetailResponseDTO.swift
//  Data
//
//  Created by yejiyun-MN on 2023/04/30.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Foundation

public struct AbilityDetailResponseDTO: Decodable {
    let abilityName: String
    let works: [WorkDTO]
    
    public func toDomain() -> AbilityDetail {
        let works = self.works.map {
            let project = Project.init(title: $0.projectTitle)
            let abilities = $0.abilityInfos.map { $0.toDomain() }
            
            return Work.init(
                id: $0.workId,
                title: $0.workTitle,
                project: project,
                description: $0.description,
                date: $0.date,
                abilities: abilities
            )
        }
        
        return AbilityDetail.init(
            abilityName: self.abilityName,
            works: works
        )
    }
}
