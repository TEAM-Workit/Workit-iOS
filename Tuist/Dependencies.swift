//
//  Dependencies.swift
//  Config
//
//  Created by 김혜수 on 2023/04/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies(
    [
        .remote(url: "https://github.com/TEAM-Workit/HorizonCalendar.git",
                requirement: .branch("main"))
    ],
    productTypes: ["HorizonCalendar": .framework]
    ),
    platforms: [.iOS]
)
