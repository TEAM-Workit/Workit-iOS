//
//  CollectionResponseDTO.swift
//  Data
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain

public struct CollectionResponseDTO: Decodable {
    let id: Int
    let name: String
    let count: Int
    
    public func toDomain() -> LibraryItem {
        return LibraryItem.init(id: self.id, name: self.name, count: self.count)
    }
}
