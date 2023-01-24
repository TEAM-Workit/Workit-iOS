//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김혜수 on 2022/11/06.
//

import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.framework(
    name: "Data",
    platform: .iOS,
    dependencies: [],
    additionalPackageDependencies: [
        .package(product: "RxAlamofire"),
        .package(product: "Alamofire")
    ],
    packages: [
        .remote(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git",
                requirement: .upToNextMinor(from: "6.1.0"))
    ],
    infoPlist:.file(path: "Plists/Info.plist"))
