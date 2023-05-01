//
//  AllAbilityResponseDTO.swift
//  Data
//
//  Created by madilyn on 2023/04/26.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct AllAbilityResponseDTO: Decodable {
    let abilities: [WriteAbilityDTO]
    
    public func toDomain() -> [Ability] {
        self.abilities.map { $0.toDomain() }
    }
    
    public struct WriteAbilityDTO: Decodable {
        let abilityId: Int
        let abilityName: String
        let abilityType: String
        
        public func toDomain() -> Ability {
            return Ability.init(
                id: self.abilityId,
                name: self.abilityName,
                type: self.abilityType
            )
        }
    }
}
