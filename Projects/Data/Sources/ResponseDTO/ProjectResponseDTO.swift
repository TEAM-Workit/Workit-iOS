//
//  ProjectResponseDTO.swift
//  Data
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct ProjectResponseDTO: Decodable {
    let id: Int
    let title: String
    let count: Int?
    
    public func toLibraryDomain() -> LibraryItem {
        return LibraryItem.init(id: self.id, name: self.title, count: self.count ?? 0)
    }
    
    public func toProjectDomain() -> Project {
        return Project.init(id: id, title: title)
    }
}
