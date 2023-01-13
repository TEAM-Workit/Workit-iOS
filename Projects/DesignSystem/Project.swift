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
    dependencies: [
        .project(target: "Global", path: "../Global")
    ],
    additionalPackageDependencies: [
        .package(product: "RxSwift"),
        .package(product: "SnapKit"),
        .package(product: "RxCocoa"),
        .package(product: "RxGesture"),
        .package(product: "HorizonCalendar")
    ],
    packages: [
        .remote(url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxGesture",
                requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/airbnb/HorizonCalendar.git",
                requirement: .upToNextMajor(from: "1.0.0"))
    ])

