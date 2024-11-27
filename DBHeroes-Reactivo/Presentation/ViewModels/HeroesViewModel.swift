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
        var data = try await useCaseHeroes.getHeroes(heroes: "")
        
        if !data.isEmpty {
            data.sort { $0.name < $1.name }
        }
        
        let sortedHeroes = data
        
        DispatchQueue.main.async {
            self.heroesList = sortedHeroes
        }
        
    }
}
