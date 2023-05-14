//
//  WithdrawalReactor.swift
//  App
//
//  Created by 김혜수 on 2023/04/22.
//  Copyright © 2023 com.workit. All rights reserved.
//

import Domain
import Foundation

import ReactorKit

final class WithdrawalReactor: Reactor {
    
    var initialState: State
    let userUseCase: UserUseCase
    
    init(userUseCase: UserUseCase) {
        self.userUseCase = userUseCase
        initialState = .init(
            agreeButtonSelected: false,
            isCompletedWithDraw: false,
            isEnableClickWithdrawButton: false)
    }
    
    enum Action {
        case agreeButtonTap
        case withdrawButtonDidTap
        case selectReason(String?)
        case etcReasonTextViewDidChange(String?)
    }
    
    struct State {
        var reason: String?
        var agreeButtonSelected: Bool
        var isCompletedWithDraw: Bool
        var isEnableClickWithdrawButton: Bool
        var etcReasonText: String?
    }
    
    enum Mutation {
        case changeAgreeButtonState
        case withDraw
        case setReason(String?)
        case setEtcReason(String?)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .agreeButtonTap:
            return Observable.just(Mutation.changeAgreeButtonState)
            
        case .withdrawButtonDidTap:
            var reason = currentState.reason ?? ""
            if reason == "기타" {
                reason = "기타 - " + (currentState.etcReasonText ?? "")
            }
            let successWithdraw = userUseCase.deleteUser(description: reason)
                .filter { $0 }
                .map { _ in Mutation.withDraw }
            return successWithdraw
            
        case .selectReason(let reason):
            return Observable.just(Mutation.setReason(reason))
            
        case .etcReasonTextViewDidChange(let text):
            return Observable.just(Mutation.setEtcReason(text))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .changeAgreeButtonState:
            newState.agreeButtonSelected.toggle()
            newState.isEnableClickWithdrawButton = setEnableWithdrawButton(
                reason: newState.reason,
                etcReason: newState.etcReasonText,
                isAgree: newState.agreeButtonSelected)
            
        case .withDraw:
            newState.isCompletedWithDraw = true
            
        case .setReason(let reason):
            newState.reason = reason
            newState.isEnableClickWithdrawButton = setEnableWithdrawButton(
                reason: newState.reason,
                etcReason: newState.etcReasonText,
                isAgree: newState.agreeButtonSelected)
            
        case .setEtcReason(let reason):
            newState.etcReasonText = reason
            newState.isEnableClickWithdrawButton = setEnableWithdrawButton(
                reason: newState.reason,
                etcReason: newState.etcReasonText,
                isAgree: newState.agreeButtonSelected)
        }
        
        return newState
    }
    
    private func setEnableWithdrawButton(reason: String?, etcReason: String?, isAgree: Bool) -> Bool {
        if reason == "기타" {
            if let etcReason = etcReason,
               !etcReason.isEmpty {
                return isAgree
            }
            return false
        }
        
        return isAgree && (reason != nil)
    }
}
