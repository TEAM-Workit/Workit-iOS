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
    dependencies: [],
    additionalPackageDependencies: [
        .package(product: "RxSwift"),
        .package(product: "RxCocoa"),
        .package(product: "RxGesture")
    ],
    packages: [
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxGesture",
                requirement: .upToNextMajor(from: "4.0.0"))
    ])
