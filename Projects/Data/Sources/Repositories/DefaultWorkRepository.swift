//
//  DefaultWorkRepository.swift
//  Data
//
//  Created by 김혜수 on 2023/01/29.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Foundation.NSDate

import RxSwift

public final class DefaultWorkRepository: WorkRepository {
    
    public init() { }
    
    public func fetchWorks() -> Observable<[Work]> {
        return NetworkService.shared.work.fetchWorks()
            .compactMap { $0.data }
            .map { $0.toDomain() }
    }
    
    public func fetchWorksDate(start: Date, end: Date) -> Observable<[Work]> {
        return NetworkService.shared.work.fetchWorksDate(start: start, end: end)
            .compactMap { $0.data }
            .map { $0.toDomain() }
    }
}
