import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "App",
    platform: .iOS,
    additionalTargets: [],
    dependencies: [
        .external(name: "HorizonCalendar"),
        .external(name: "RxKakaoSDKAuth"),
        .external(name: "RxKakaoSDKUser"),
        .external(name: "ReactorKit"),
        .external(name: "SnapKit"),
        .external(name: "RxGesture"),
        .external(name: "FirebaseAnalytics"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseMessaging"),
        .project(target: "Data", path: "../Data"),
        .project(target: "DesignSystem", path: "../DesignSystem"),
        .project(target: "Global", path: "../Global"),
        .project(target: "Domain", path: "../Domain")
    ],
    packages: [],
    infoPlist: .file(path: "Plists/Info.plist")
)
