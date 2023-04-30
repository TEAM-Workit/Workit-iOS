//
//  TagType.swift
//  Global
//
//  Created by 김혜수 on 2022/12/09.
//  Copyright © 2022 com.workit. All rights reserved.
//

public enum TagType: String {
    case hard
    case soft
    
    public init(rawValue: String) {
        switch rawValue {
        case "HARD", "hard":
            self = .hard
        case "SOFT", "soft":
            self = .soft
        default:
            fatalError("HARD, SOFT 아님")
        }
    }
}
