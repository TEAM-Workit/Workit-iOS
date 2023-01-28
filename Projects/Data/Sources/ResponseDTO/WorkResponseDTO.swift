//
//  WorkitResponseDTO.swift
//  Data
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

public struct WorksResponseDTO: Decodable {
    let works: [WorkDTO]
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
}
