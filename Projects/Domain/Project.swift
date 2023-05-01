import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.framework(
    name: "Domain",
    platform: .iOS,
    dependencies: [
        .external(name: "RxSwift"),
        .project(target: "Global", path: "../Global")
    ],
    additionalPackageDependencies: [],
    packages: [])
