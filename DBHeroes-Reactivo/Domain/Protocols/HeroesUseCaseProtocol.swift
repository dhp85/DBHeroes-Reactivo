//
//  HeroesUseCaseProtocol.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//
import Foundation

protocol HeroesUseCaseProtocol {
    var repo: HeroesRepositoryProtocol { get set }
    func getHeroes(heroes: String) async throws -> [HeroesModel]
}
