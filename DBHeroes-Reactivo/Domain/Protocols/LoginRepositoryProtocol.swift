//
//  LoginRepositoryProtocol.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation

protocol LoginRepositoryProtocol {
    func login(user:String, password:String) async throws -> String
}
