//
//  DefaultCollectionRepository.swift
//  Data
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Global

import RxSwift

public final class DefaultCollectionRepository: CollectionRepository {
    
    public init() { }
    
    public func fetchProjects() -> Observable<[LibraryItem]> {
        return NetworkService.shared.collection.fetchProjects()
            .compactMap { $0.data }
            .map { libraryItems in
                return libraryItems.map { $0.toDomain() }
            }
    }
    
    public func fetchAbilities() -> Observable<[LibraryItem]> {
        return NetworkService.shared.collection.fetchAbilites()
            .compactMap { $0.data }
            .map { libraryItems in
                return libraryItems.map { $0.toDomain() }
            }
    }
    
}
