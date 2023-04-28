//
//  WorkRepository.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation.NSDate

import RxSwift

public protocol WorkRepository {
    func fetchWorks() -> Observable<[Work]>
    func fetchWorksDate(start: Date, end: Date) -> Observable<[Work]>
    func fetchWorkDetail(workId: Int, completion: @escaping (WorkDetail) -> Void)
    func createWork(data: NewWork, completion: @escaping (WorkDetail?) -> Void)
    func updateWork(data: NewWork, workId: Int,completion: @escaping (WorkDetail?) -> Void)
}
