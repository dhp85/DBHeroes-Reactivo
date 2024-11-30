//
//  HeroesUseCase.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import Foundation

final class HeroesUseCase: HeroesUseCaseProtocol {
    var repo: HeroesRepositoryProtocol
    
    init(repo: HeroesRepositoryProtocol = HeroesRepository(network: HeroesNetwork())) {
        self.repo = repo
    }
    
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        return try await repo.getHeroes(heroes: heroes)
    }
}

    // MARK: - HeroesUseCaseFake

final class HeroesUseCaseFake: HeroesUseCaseProtocol {
    var repo: HeroesRepositoryProtocol
    
    init(repo: HeroesRepositoryProtocol = HeroesRepository(network: NetworkHerosFake())) {
        self.repo = repo
    }
    
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        return try await repo.getHeroes(heroes: heroes)
    }
    
    
}
