//
//  ProjectRequestDTO.swift
//  Data
//
//  Created by 윤예지 on 2023/03/14.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Foundation

public struct ProjectRequestDTO: Encodable {
    let title: String

    public init(title: String) {
        self.title = title
    }
}
