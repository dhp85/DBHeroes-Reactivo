//
//  LoginViewModel.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation

enum LoginStatus {
    case none
    case success
    case error
    case notValidate
}

class LoginViewModel: ObservableObject {
    @Published var statusLogin: LoginStatus = .none
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    func login(username: String, password: String) {
        Task {
            if (await loginUseCase.login(user: username, password: password)) {
                self.statusLogin = .success
            } else {
                self.self .statusLogin = .error
            }
        }
    }
    
    func validateControlLogin() {
        Task {
            if (await loginUseCase.validateToken()) {
                self.statusLogin = .success
            } else {
                self.self .statusLogin = .notValidate
            }
        }
    }
    
    func closeSessionUser() {
        Task {
            await loginUseCase.logout()
            self.statusLogin = .none
        }
    }
}
