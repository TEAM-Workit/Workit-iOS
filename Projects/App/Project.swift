import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "App",
    platform: .iOS,
    additionalTargets: [],
    dependencies: [
        .project(target: "Data", path: "../Data"),
        .project(target: "DesignSystem", path: "../DesignSystem"),
        .project(target: "Global", path: "../Global"),
        .project(target: "Domain", path: "../Domain")
    ],
    packages: [
        .remote(url: "https://github.com/ReactorKit/ReactorKit.git",
                requirement: .upToNextMajor(from: "3.0.0")),
        .remote(url: "https://github.com/SnapKit/SnapKit.git",
                requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxAlamofire.git",
                requirement: .upToNextMajor(from: "6.1.0")),
        .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                requirement: .upToNextMinor(from: "6.5.0")),
        .remote(url: "https://github.com/RxSwiftCommunity/RxGesture",
                requirement: .upToNextMajor(from: "4.0.0")),
        .remote(url: "https://github.com/airbnb/HorizonCalendar.git",
                requirement: .upToNextMajor(from: "1.0.0"))
    ],
    infoPlist: .file(path: "Plists/Info.plist")
)
