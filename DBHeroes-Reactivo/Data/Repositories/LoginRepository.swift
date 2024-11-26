//
//  LoginRepository.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation

final class DefaultLoginRepository: LoginRepositoryProtocol {
   
    
    private var network: LoginNetworkprotocol
    
    init(network: LoginNetworkprotocol) {
        self.network = network
    }
    
    func login(user: String, password: String) async throws -> String {
        return try await network.login(username: user, password: password)
    }
}
