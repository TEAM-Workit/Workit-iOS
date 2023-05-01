//
//  ExpectingObservable+.swift
//  Data
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

import RxSwift

extension Observable where Element == (HTTPURLResponse, Any) {
    
    public func expectingObject<T: Decodable>(ofType type: T.Type) -> Observable<T> {
        return self.map { (response, value) in
            
            if 200...500 ~= response.statusCode {
                if let object: T = JsonConverter.toJson(object: value) {
                    print("-----------------------------SUCCESS")
                    print(response.url ?? "")
                    print(response.statusCode)
                    print(response.headers)
                    print(object)
                    print(value)
                    print("-----------------------------")
                    return object
                } else {
                    throw HTTPError.unknown
                }
            } else {
                print(response, value)
                print("-----------------------------")
                throw HTTPError(rawValue: response.statusCode) ?? .unknown
            }
        }
    }
}
