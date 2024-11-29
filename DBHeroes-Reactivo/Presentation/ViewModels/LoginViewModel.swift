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
    case loading
}

final class LoginViewModel: ObservableObject {
    @Published var statusLogin: LoginStatus = .none
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func login(username: String, password: String) {
        Task {
            do {
                self.statusLogin = .loading
                let success = try await loginUseCase.login(user: username, password: password)
                if success {
                    self.statusLogin = .success
                } else {
                    self.statusLogin = .error
                }
            } catch {
                self.statusLogin = .error
            }
        }
    }
}
