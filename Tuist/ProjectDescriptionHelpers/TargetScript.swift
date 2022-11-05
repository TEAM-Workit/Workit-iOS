//
//  TargetScript.swift
//  ProjectDescriptionHelpers
//
//  Created by 김혜수 on 2022/11/05.
//

import ProjectDescription

extension TargetScript {
    static let swiftlint = TargetScript.pre(
        script: "../../Scripts/SwiftLintRunScript.sh",
        name: "SwiftLint"
    )
}
