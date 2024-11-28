//
//  DetailUseCase.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation

final class DetailUseCase: DetailUseCaseProtocol {
    var repo: DetailHeroesRepositoryProtocol
    
    init(repo: DetailHeroesRepositoryProtocol = HeroesDetailRepository(network: DetailNetwork())) {
        self.repo = repo
    }
    
    func getTransformations(id: String) async throws -> [TransformationModel] {
        return try await repo.getTransformations(id: id)
    }
    
    
}
