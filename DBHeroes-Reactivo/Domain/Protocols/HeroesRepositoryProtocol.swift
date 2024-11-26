//
//  HeroesRepositoryProtocol.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import Foundation

protocol HeroesRepositoryProtocol {
    func getHeroes(heroes: String) async throws -> [HeroesModel]
}
