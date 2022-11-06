import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "App",
    platform: .iOS,
    additionalTargets: [],
    dependencies: [
        .project(target: "Data", path: "../Data"),
        .project(target: "DesignSystem", path: "../DesignSystem")
    ])
