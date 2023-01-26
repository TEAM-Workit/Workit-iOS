import ProjectDescriptionHelpers
import ProjectDescription

let project = Project.framework(
    name: "Domain",
    platform: .iOS,
    dependencies: [],
    additionalPackageDependencies: [
        .package(product: "RxSwift")
    ],
    packages: [
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0"))
    ])
