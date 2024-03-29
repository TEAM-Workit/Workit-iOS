//
//  BaseRequestConvertible.swift
//  Data
//
//  Created by 김혜수 on 2023/01/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation
import Global

import Alamofire

protocol BaseRequestConvertible: URLRequestConvertible { }

extension BaseRequestConvertible {

    var baseURL: URL {
        return URL(string: SecretKey.baseURL)!
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json",
                "Authorization": UserDefaultsManager.shared.accessToken ?? ""]
    }
}

protocol AuthBaseRequestConvertible: URLRequestConvertible { }

extension AuthBaseRequestConvertible {
    
    var baseURL: URL {
        return URL(string: SecretKey.baseURL)!
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
}
