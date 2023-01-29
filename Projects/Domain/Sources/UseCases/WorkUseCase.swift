//
//  WorkUseCase.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import RxSwift

public protocol WorkUseCase {
    func fetchWorks() -> Observable<[Work]>
    func fetchWorksDate(start: Date, end: Date) -> Observable<[Work]>
}

public final class DefaultWorkUseCase: WorkUseCase {
    
    private let workRepository: WorkRepository
    
    public init(workRepository: WorkRepository) {
        self.workRepository = workRepository
    }
    
    public func fetchWorks() -> Observable<[Work]> {
        return workRepository.fetchWorks()
    }
    
    public func fetchWorksDate(start: Date, end: Date) -> Observable<[Work]> {
        return workRepository.fetchWorksDate(start: start, end: end)
    }
}
