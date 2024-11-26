//
//  HeroesRepository.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import Foundation

final class HeroesRepository: HeroesRepositoryProtocol {
    private var network: HeroesNetworkProtocol
    
    init(network: HeroesNetworkProtocol) {
        self.network = network
    }
    
    
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        return try await network.getHeroes(heroes: heroes)
    }
}
