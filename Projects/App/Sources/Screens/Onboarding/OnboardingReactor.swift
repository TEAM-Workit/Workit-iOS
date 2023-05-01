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
    
    enum Number {
        static let deviceWidth: CGFloat = UIScreen.main.bounds.width
        static let lastPage: Int = 2
    }

    enum Text {
        static let title1: String = "원하는 만큼만, 가볍게"
        static let title2: String = "기록과 스킬이 딱 들어맞는 정리"
        static let title3: String = "경험 정리를 한 순간에!"
        static let subtitle1: String = "지금이 아니면 언제 기억날지 몰라요!\n완벽하지 않아도 되니 일단 시작해보세요."
        static let subtitle2: String = "그 날 그 날의 업무기록을 직무 역량과 연결하면,\n워킷에서 보기 쉽게 정리해드려요"
        static let subtitle3: String = "공고 속 자격요건에 적합한 경험들만\n쏙쏙 모아보세요."
        static let next: String = "다음"
        static let start: String = "시작하기"
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
            onboardings: self.onboardings,
            buttonTitle: Text.next,
            startButtonTap: false
        )
    }

    enum Action {
        case viewWillAppear
        case collectionViewScrolled(Int)
        case nextButtonDidTap
    }

    struct State {
        var page: Int
        var onboardings: [Onboarding]
        var buttonTitle: String
        var startButtonTap: Bool
    }

    enum Mutation {
        case setPage(Int)
        case setNextPage
        case void
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.just(Mutation.void)
            
        case let .collectionViewScrolled(page):
            return Observable.just(Mutation.setPage(page))
            
        case .nextButtonDidTap:
            return Observable.just(Mutation.setNextPage)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setPage(page):
            newState.page = page
            newState.buttonTitle = getButtonTitle(page: page)
            
        case .setNextPage:
            if newState.page >= Number.lastPage {
                newState.startButtonTap = true
                break
            }
            
            if newState.page < Number.lastPage {
                newState.page += 1
            }
            newState.buttonTitle = getButtonTitle(page: newState.page)
            
        case .void:
            break
        }
        
        return newState
    }
    
    private func getButtonTitle(page: Int) -> String {
        let isLastPage: Bool = (page == Number.lastPage)
        return isLastPage ? Text.start : Text.next
    }
}
