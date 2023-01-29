//
//  NetworkService.swift
//  Data
//
//  Created by 김혜수 on 2023/01/25.
//  Copyright © 2023 com.workit. All rights reserved.
//

public final class NetworkService {
    public static let shared = NetworkService()

    private init() { }

    public let auth: AuthService = DefaultAuthService()
    public let work: WorkService = DefaultWorkService()
}
