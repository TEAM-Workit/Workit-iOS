//
//  Dependencies.swift
//  Config
//
//  Created by 김혜수 on 2023/04/11.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies(
        [.remote(url: "https://github.com/TEAM-Workit/HorizonCalendar.git", requirement: .branch("main")),
         .remote(url: "https://github.com/kakao/kakao-ios-sdk-rx", requirement: .branch("master")),
         .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMajor(from: "3.0.0")),
         .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.0.1")),
         .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.0")),
         .remote(url: "https://github.com/firebase/firebase-ios-sdk", requirement: .upToNextMajor(from: "9.0.0")),
         .remote(url: "https://github.com/mixpanel/mixpanel-swift", requirement: .branch("master"))
         ],
        productTypes: ["HorizonCalendar": .framework, "ReactorKit": .framework]
    ),
    platforms: [.iOS]
)
