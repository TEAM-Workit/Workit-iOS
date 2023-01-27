//
//  Onboarding.swift
//  App
//
//  Created by 김혜수 on 2023/01/17.
//  Copyright © 2023 com.workit. All rights reserved.
//

import UIKit

struct Onboarding: Hashable {
    let title: String
    let subtitle: String
    let image: UIImage

    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(image)
    }
}
