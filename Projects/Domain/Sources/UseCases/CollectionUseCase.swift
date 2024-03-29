//
//  CollectionUseCase.swift
//  Domain
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import Global

import RxSwift

public protocol CollectionUseCase {
    func projects() -> Observable<[LibraryItem]>
    func abilities() -> Observable<[LibraryItem]>
}

public final class DefaultCollectionUseCase: CollectionUseCase {
    private let collectionRepository: CollectionRepository

    public init(collectionRepository: CollectionRepository) {
        self.collectionRepository = collectionRepository
    }

    public func projects() -> RxSwift.Observable<[LibraryItem]> {
        return collectionRepository.fetchProjects()
    }
    
    public func abilities() -> Observable<[LibraryItem]> {
        return collectionRepository.fetchAbilities()
    }
}
