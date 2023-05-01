//
//  WorkRequestDTO.swift
//  Data
//
//  Created by madilyn on 2023/04/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import Global

public struct WorkRequestDTO: Encodable {
    let date: String
    let projectId: Int
    let workTitle: String
    let description: String
    let abilities: [Int]
    
    public init(date: Date, projectId: Int, workTitle: String, desciption: String, abilities: [Int]) {
        self.date = date.toString(type: .full)
        print(self.date)
        self.projectId = projectId
        self.workTitle = workTitle
        self.description = desciption
        self.abilities = abilities
    }
}
