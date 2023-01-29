//
//  WorkRepository.swift
//  Domain
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import RxSwift

public protocol WorkRepository {
    func fetchWorks() -> Observable<[Work]>
}
