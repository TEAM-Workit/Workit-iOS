import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: additionalTargets.map {
                TargetDependency.target(name: $0)
            })
        
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        
        return Project(
            name: name,
            organizationName: workitOrganizationName,
            options: .options(disableBundleAccessors: true),
            packages: [
                .remote(url: "https://github.com/ReactorKit/ReactorKit.git",
                        requirement: .upToNextMajor(from: "3.0.0")),
                .remote(url: "https://github.com/SnapKit/SnapKit.git",
                        requirement: .upToNextMajor(from: "5.0.1")),
                .remote(url: "https://github.com/devxoul/Then",
                        requirement: .upToNextMajor(from: "2")),
                .remote(url: "https://github.com/Alamofire/Alamofire.git",
                        requirement: .upToNextMajor(from: "5.6.1")),
                .remote(url: "https://github.com/ReactiveX/RxSwift.git",
                        requirement: .upToNextMinor(from: "6.5.0"))
            ],
            targets: targets)
    }
   
    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: "\(workitOrganizationName).\(name)",
            infoPlist: .default,
            sources: ["\(name)/Sources/**"],
            resources: [],
            dependencies: [
            ])
        
        return [sources]
        
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            productName: "Workit",
            bundleId: "\(workitOrganizationName).\(name)",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: [.iphone]),
            infoPlist: .file(path: "Applications/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            scripts: [.swiftlint],
            dependencies: dependencies + [
                .package(product: "ReactorKit"),
                .package(product: "Snapkit"),
                .package(product: "Then"),
                .package(product: "Alamofire"),
                .package(product: "RxCocoa")
//                .external(name: "ReactorKit"),
//                .external(name: "SnapKit"),
//                .external(name: "Then"),
//                .external(name: "Alamofire"),
//                .external(name: "RxCocoa")
            ]
        )

        return [mainTarget]
    }
}
