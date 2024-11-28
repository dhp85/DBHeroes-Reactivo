//
//  DetailHeroesViewModel.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//
import Foundation

final class DetailHeroesViewModel: ObservableObject {
    @Published var hero: HeroesModel
    @Published var transformation = [TransformationModel]()
    
    private var useCase: DetailUseCaseProtocol
    
    init(hero: HeroesModel,useCase: DetailUseCaseProtocol = DetailUseCase()) {
        self.hero = hero
        self.useCase = useCase
        Task {
            try await gettransformations()
        }
    }
    
    func gettransformations() async throws {
        
        let data = try await useCase.getTransformations(id: hero.id)
        
        DispatchQueue.main.async {
            self.transformation = data
        }
    }
    
    func clearTransformations() {
        self.transformation = [] 

    }
}
