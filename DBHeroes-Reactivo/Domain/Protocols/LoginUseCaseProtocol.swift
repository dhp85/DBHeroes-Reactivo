//
//  LoginUseCaseProtocol.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation

protocol LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol { get set }
    func login(user: String, password: String) async throws -> Bool
}
