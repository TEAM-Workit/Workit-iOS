import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
    
    public static func app(
        name: String,
        platform: Platform,
        additionalTargets: [String],
        dependencies: [TargetDependency] = [],
        packages: [ProjectDescription.Package],
        infoPlist: ProjectDescription.InfoPlist)
    -> Project {
            
        let targets = makeAppTargets(
            name: name,
            platform: platform,
            dependencies: dependencies,
            infoPlist: infoPlist)
        
        return Project(
            name: name,
            organizationName: workitOrganizationName,
            options: .options(disableBundleAccessors: true),
            packages: packages,
            targets: targets)
    }
    
    public static func framework(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency] = [],
        additionalPackageDependencies: [TargetDependency] = [],
        packages: [ProjectDescription.Package] = [],
        infoPlist: ProjectDescription.InfoPlist = .default
    ) -> Project {
        
        let targets = makeFrameworkTargets(
            name: name,
            platform: platform,
            dependencies: dependencies,
            additionalPackageDependencies: additionalPackageDependencies, 
            infoPlist: infoPlist)
        
        return Project(
            name: name,
            organizationName: workitOrganizationName,
            packages: packages,
            targets: targets)
    }
   
    // MARK: - Private
    
    private static func makeAppTargets(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency],
        infoPlist: ProjectDescription.InfoPlist)
    -> [Target] {
            
        let bundleId = "com.workit.jeonsuyeol"

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            productName: "Workit",
            bundleId: bundleId,
            deploymentTarget: targetVersion,
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "App.entitlements",
            scripts: [.swiftlint],
            dependencies: dependencies + []
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: bundleId,
            deploymentTarget: targetVersion,
            infoPlist: infoPlist,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        
        return [mainTarget, testTarget]
    }
    
    private static func makeFrameworkTargets(
        name: String,
        platform: Platform,
        dependencies: [TargetDependency],
        additionalPackageDependencies: [TargetDependency],
        infoPlist: ProjectDescription.InfoPlist
    ) -> [Target] {
        
        let bundleId = "\(workitOrganizationName).\(name)"
        
        let sources = Target(
            name: name,
            platform: platform,
            product: .framework,
            bundleId: bundleId,
            deploymentTarget: targetVersion,
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: dependencies + additionalPackageDependencies)
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: bundleId,
            deploymentTarget: targetVersion,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "\(name)")
            ])
        
        return [sources, testTarget]
    }
}
