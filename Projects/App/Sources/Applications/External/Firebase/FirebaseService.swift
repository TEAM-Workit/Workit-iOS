//
//  FirebaseService.swift
//  AppTests
//
//  Created by 김혜수 on 2023/05/27.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Firebase
import FirebaseRemoteConfig
import RxSwift

final class FirebaseService {

    static let shared = FirebaseService()

    private let config = RemoteConfig.remoteConfig()
    struct State {
        var minimumVersion: String?
    }

    private var state = State()
    private let statePublisher = PublishSubject<State>()

    var stateValuePublisher: PublishSubject<State> {
        if state.minimumVersion != nil {
            fetch()
        }
        return statePublisher
    }

    var stateValue: State {
        return state
    }

    private init() {
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0
        setting.fetchTimeout = 1
        config.configSettings = setting
    }

    func start() {
        fetch()
    }

    private func fetch() {
        config.fetch { [weak self] status, _ -> Void in
            guard
                let self = self,
                status == .success
            else {
                self?.statePublisher.onNext(self?.state ?? State(minimumVersion: "1.0.0"))
                return
            }
            self.config.activate { _, _ in }
            self.fetchValue()
            return
        }
    }

    private func fetchValue() {
        guard
            let version = config["minimum_version"].stringValue
        else {
            statePublisher.onNext(state)
            return
        }
        let newState = State(
            minimumVersion: version
        )
        statePublisher.onNext(newState)
        state = newState
    }

}
