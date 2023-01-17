//
//  OnboardingReactor.swift
//  App
//
//  Created by 김혜수 on 2023/01/13.
//  Copyright © 2023 com.workit. All rights reserved.
//

import DesignSystem
import UIKit

import ReactorKit

final class OnboardingReactor: Reactor {

    enum Text {
        static let title1 = "원하는 만큼만, 가볍게"
        static let title2 = "기록과 스킬이 딱 들어맞는 정리"
        static let title3 = "경험 정리를 한 순간에!"
        static let subtitle1 = "지금이 아니면 언제 기억날지 몰라요!\n완벽하지 않아도 되니 일단 시작해보세요."
        static let subtitle2 = "그 날 그 날의 업무기록을 직무 역량과 연결하면,\n워킷에서 보기 쉽게 정리해드려요"
        static let subtitle3 = "공고 속 자격요건에 적합한 경험들만\n쏙쏙 모아보세요."
    }

    var initialState: State

    private let onboardings: [Onboarding] = [
        Onboarding(
            title: Text.title1,
            subtitle: Text.subtitle1,
            image: Image.wkOnboarding1),
        Onboarding(
            title: Text.title2,
            subtitle: Text.subtitle2,
            image: Image.wkOnboarding2),
        Onboarding(
            title: Text.title3,
            subtitle: Text.subtitle3,
            image: Image.wkOnboarding3)]

    init() {
        initialState = .init(
            page: 0,
            onboardings: self.onboardings)
    }

    enum Action {
        case viewWillAppear
    }

    struct State {
        var page: Int
        var onboardings: [Onboarding]
    }

    enum Mutation { }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        return newState
    }
}
