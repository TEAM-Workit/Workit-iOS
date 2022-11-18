//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김혜수 on 2022/11/06.
//

import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.framework(
    name: "DesignSystem",
    platform: .iOS,
    dependencies: [],
    additionalPackageDependencies: [
        .package(product: "RxSwift"),
        .package(product: "SnapKit"),
        .package(product: "RxCocoa")
    ],
    packages: [
        .remote(url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0"))
    ])

