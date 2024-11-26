//
//  HeroesViewModel.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//
import Foundation

final class HeroesViewModel: ObservableObject {
    @Published var heroesList = [HeroesModel]()
    
    private var useCaseHeroes: HeroesUseCaseProtocol
    
    init(useCaseHeroes: HeroesUseCaseProtocol = HeroesUseCase()) {
        self.useCaseHeroes = useCaseHeroes
        Task {
            try await getHeroes()
        }
    }
    
    func getHeroes() async throws{
        let data = try await useCaseHeroes.getHeroes(heroes: "")
        
        DispatchQueue.main.async {
            self.heroesList = data
        }
        
    }
}
