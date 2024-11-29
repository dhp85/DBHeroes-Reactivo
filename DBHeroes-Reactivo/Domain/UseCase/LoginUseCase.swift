//
//  LoginUseCase.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation
import KcLibrarySwift1

final class LoginUseCase: LoginUseCaseProtocol {
    
    
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: LoginNetwork())) {
        self.repo = repo
    }
    func login(user: String, password: String) async throws -> Bool {
        let token = try await repo.login(user: user, password: password)
        
        if token != "" {
            KeyChainKc().saveKC(CONST_TOKEN_ID_KEYCHAIN, value: token)
            return true
        } else {
            KeyChainKc().deleteKC(key: CONST_TOKEN_ID_KEYCHAIN)
            return false
        }
    }
}

final class LoginUseCaseFake: LoginUseCaseProtocol {
    func login(user: String, password: String) async throws -> Bool {
        KeyChainKc().saveKC(CONST_TOKEN_ID_KEYCHAIN, value: "LoginFakeSuccess")
        return true
    }
    
    
    
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: LoginNetwork())) {
        self.repo = repo
    }
}
