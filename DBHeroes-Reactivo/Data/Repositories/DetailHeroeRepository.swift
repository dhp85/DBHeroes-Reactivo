//
//  DetailHeroeRepository.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation

final class HeroesDetailRepository: DetailHeroesRepositoryProtocol {
    
    private var network: DetailNetworkProtocol
    
    init(network: DetailNetworkProtocol) {
        self.network = network
    }
    
    func gettransformations(id: String) async throws -> [TransformationModel] {
        return try await network.getTransformations(id: id)
    }
}
