//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김혜수 on 2022/11/21.
//

import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.framework(
    name: "Global",
    platform: .iOS,
    dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxGesture")
    ],
    additionalPackageDependencies: [],
    packages: [])
