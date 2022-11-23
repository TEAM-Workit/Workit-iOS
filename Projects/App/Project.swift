import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "App",
    platform: .iOS,
    additionalTargets: [],
    dependencies: [
        .project(target: "Data", path: "../Data"),
        .project(target: "DesignSystem", path: "../DesignSystem"),
        .project(target: "Global", path: "../Global")
    ],
    packages: [
        .remote(url: "https://github.com/ReactorKit/ReactorKit.git",
                requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/Alamofire/Alamofire.git",
                requirement: .upToNextMajor(from: "5.6.1")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0"))
    ],
    infoPlist: .file(path: "Plists/Info.plist")
)
