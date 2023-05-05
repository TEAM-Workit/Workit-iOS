//
//  UserDefaultsUtil.swift
//  Global
//
//  Created by 김혜수 on 2023/04/23.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

public struct UserDefaultsManager {
    
    public static var shared = UserDefaultsManager()
    
    private init() {}
    
    public var accessToken: String? {
        get {
            return UserDefaults.standard.object(forKey: "accessToken") as? String ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
    
    public var fcmToken: String? {
        get {
            return UserDefaults.standard.object(forKey: "fcmToken") as? String ?? nil
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "fcmToken")
        }
    }
    
    public func removeToken() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
    }
}
