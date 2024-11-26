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
    func login(user: String, password: String) async -> Bool {
        let token = await repo.login(user: user, password: password)
        
        if token != "" {
            KeyChainKc().saveKC(CONST_TOKEN_ID_KEYCHAIN, value: token)
            return true
        } else {
            KeyChainKc().deleteKC(key: CONST_TOKEN_ID_KEYCHAIN)
            return false
        }
    }
    
    func logout() async {
        KeyChainKc().deleteKC(key: CONST_TOKEN_ID_KEYCHAIN)
    }
    
    func validateToken() async -> Bool {
        if KeyChainKc().loadKC(key: CONST_TOKEN_ID_KEYCHAIN) != "" {
            return true
        } else {
            return false
        }
    }
}
