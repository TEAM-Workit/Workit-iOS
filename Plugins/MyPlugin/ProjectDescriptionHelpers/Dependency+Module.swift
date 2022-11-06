//
//  Dependency+Module.swift
//  MyPlugin
//
//  Created by 김혜수 on 2022/11/05.
//


import ProjectDescription

public extension ProjectDescription.Path {
    static func relativeToSections(_ path: String) -> Self {
        return .relativeToRoot("Projects/\(path)")
    }
    
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

public extension TargetDependency {
    static func project(name: String) -> Self {
        return .project(target: name, path: .relativeToSections(name))
    }
}
