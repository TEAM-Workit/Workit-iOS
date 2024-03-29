//
//  WorkService.swift
//  Data
//
//  Created by 김혜수 on 2023/01/28.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation.NSDate

import Alamofire
import RxAlamofire
import RxSwift

public protocol WorkService {
    func fetchWorks() -> Observable<BaseResponseType<WorksResponseDTO>>
    func fetchWorksDate(start: Date, end: Date) -> Observable<BaseResponseType<WorksResponseDTO>>
    func fetchWorkDetail(workId: Int, completion: @escaping (BaseResponseType<WorkDetailDTO>) -> Void)
    func createWork(data: WorkRequestDTO, completion: @escaping (BaseResponseType<WorkDetailDTO>) -> Void)
    func updateWork(data: WorkRequestDTO, workId: Int, completion: @escaping (BaseResponseType<WorkDetailDTO>) -> Void)
    func deleteWork(workId: Int, completion: @escaping (Bool) -> Void)
}

public final class DefaultWorkService: WorkService {

    public func fetchWorks() -> Observable<BaseResponseType<WorksResponseDTO>> {
        return RxAlamofire.requestJSON(WorkRouter.fetchWorks)
            .expectingObject(ofType: BaseResponseType<WorksResponseDTO>.self)
    }
    
    public func fetchWorksDate(start: Date, end: Date) -> Observable<BaseResponseType<WorksResponseDTO>> {
        return RxAlamofire.requestJSON(WorkRouter.fetchWorksDate(start: start, end: end))
            .expectingObject(ofType: BaseResponseType<WorksResponseDTO>.self)
    }
    
    public func fetchWorkDetail(workId: Int, completion: @escaping (BaseResponseType<WorkDetailDTO>) -> Void) {
        AF.request(WorkRouter.fetchWorkDetail(workId: workId))
            .responseDecodable(of: BaseResponseType<WorkDetailDTO>.self) { response in
                if let result = response.value {
                    completion(result)
                }
            }
    }
    
    public func createWork(data: WorkRequestDTO, completion: @escaping (BaseResponseType<WorkDetailDTO>) -> Void) {
        AF.request(WorkRouter.createWork(data: data))
            .responseDecodable(of: BaseResponseType<WorkDetailDTO>.self) { response in
                if let result = response.value {
                    completion(result)
                }
            }
    }
    
    public func updateWork(data: WorkRequestDTO, workId: Int, completion: @escaping (BaseResponseType<WorkDetailDTO>) -> Void) {
        AF.request(WorkRouter.updateWork(data: data, workId: workId))
            .responseDecodable(of: BaseResponseType<WorkDetailDTO>.self) { response in
                if let result = response.value {
                    completion(result)
                }
            }
    }
    
    public func deleteWork(workId: Int, completion: @escaping (Bool) -> Void) {
        AF.request(WorkRouter.deleteWork(workId: workId))
            .responseDecodable(of: BaseResponseType<String>.self) { response in
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 {
                        completion(true)
                    } else { completion(false) }
                }
            }
    }
}
