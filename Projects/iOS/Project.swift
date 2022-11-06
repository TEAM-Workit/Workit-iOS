import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "Workit-iOS",
    platform: .iOS,
    additionalTargets: [],
    dependencies: [
        .project(target: "Data", path: "../Data"),
        .project(target: "DesignSystem", path: "../DesignSystem")
    ])
