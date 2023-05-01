//
//  CollectionRepository.swift
//  Domain
//
//  Created by yjiyuni-MN on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Global

import RxSwift

public protocol CollectionRepository {
    func fetchProjects() -> Observable<[LibraryItem]>
    func fetchAbilities() -> Observable<[LibraryItem]>
}
