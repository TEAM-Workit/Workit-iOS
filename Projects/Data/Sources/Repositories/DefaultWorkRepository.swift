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
    
    public func fetchWorkDetail(workId: Int, completion: @escaping (WorkDetail) -> Void) {
        NetworkService.shared.work.fetchWorkDetail(workId: workId) { data in
            if let workDetailDTO = data.data {
                completion(workDetailDTO.toDomain())
            }
        }
    }
    
    public func createWork(data: NewWork, completion: @escaping (WorkDetail?) -> Void) {
        let requestDTO = WorkRequestDTO.init(
            date: data.date,
            projectId: data.projectId,
            workTitle: data.title,
            desciption: data.description,
            abilities: data.abilityIds
        )
        
        NetworkService.shared.work.createWork(data: requestDTO) { data in
            if let workDetailDTO = data.data {
                completion(workDetailDTO.toDomain())
            } else {
                completion(nil)
            }
        }
    }
    
    public func updateWork(data: NewWork, workId: Int, completion: @escaping (WorkDetail?) -> Void) {
        let requestDTO = WorkRequestDTO.init(
            date: data.date,
            projectId: data.projectId,
            workTitle: data.title,
            desciption: data.description,
            abilities: data.abilityIds
        )
        
        NetworkService.shared.work.updateWork(data: requestDTO, workId: workId) { data in
            if let workDetailDTO = data.data {
                completion(workDetailDTO.toDomain())
            } else {
                completion(nil)
            }
        }
    }
}
