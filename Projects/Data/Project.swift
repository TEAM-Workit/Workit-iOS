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
    dependencies: [
        .external(name: "RxAlamofire"),
        .project(target: "Global", path: "../Global")
    ],
    additionalPackageDependencies: [],
    packages: [],
    infoPlist:.file(path: "Plists/Info.plist"))
