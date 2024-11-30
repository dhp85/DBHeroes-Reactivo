//
//  HeroesNetwork.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import Foundation
import KcLibrarySwift1

// MARK: - Protocols

protocol HeroesNetworkProtocol {
    func getHeroes(heroes: String) async throws -> [HeroesModel]
}

// MARK: - Network Implementation

final class HeroesNetwork: HeroesNetworkProtocol {
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        var heroesList: [HeroesModel] = []
        let url: String = "\(CONST_URL_SECRET)\(EndPoints.heros.rawValue)"
        
        // Request configuration
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(HeroModelRequest(name: heroes))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-Type")
        
        // Add token if available
        let token = KeyChainKc().loadKC(key: CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJwt = token {
            request.addValue("Bearer \(tokenJwt)", forHTTPHeaderField: "Authorization")
        }
        
        // Perform network call
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let resp = response as? HTTPURLResponse, resp.statusCode == 200 {
                heroesList = try JSONDecoder().decode([HeroesModel].self, from: data)
                heroesList = heroesList.sorted(by: { $0.name < $1.name })
            }
        } catch {
            throw AppError.dataNoReceived
        }
        
        return heroesList
    }
}

// MARK: - Fake Network Implementation

final class NetworkHerosFake: HeroesNetworkProtocol {
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        return getHerosFromJson()
    }
}

// MARK: - Helpers

func getHerosFromJson() -> [HeroesModel] {
    if let url = Bundle.main.url(forResource: "heroes", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([HeroesModel].self, from: data)
            return jsonData
        } catch {
            print("error: \(error)")
        }
    }
    return []
}

func getHerosHardcoded() -> [HeroesModel] {
    let model1 = HeroesModel(
        favorite: true,
        description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra...",
        id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
        name: "Goku",
        photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300"
    )

    let model2 = HeroesModel(
        favorite: true,
        description: "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable...",
        id: "6E1B907C-EB3A-45BA-AE03-44FA251F64E9",
        name: "Vegeta",
        photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300"
    )

    return [model1, model2]
}
