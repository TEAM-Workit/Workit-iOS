//
//  ClassName.swift
//  Global
//
//  Created by 김혜수 on 2022/12/21.
//  Copyright © 2022 com.workit. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        return String(describing: self)
    }

    var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}
