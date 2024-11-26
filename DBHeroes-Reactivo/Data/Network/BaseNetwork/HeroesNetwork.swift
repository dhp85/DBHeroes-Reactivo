//
//  HeroesNetwork.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import Foundation
import KcLibrarySwift1

protocol HeroesNetworkProtocol {
    func getHeroes(heroes: String) async throws-> [HeroesModel]
}


final class HeroesNetwork: HeroesNetworkProtocol {
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        var heroeslist: [HeroesModel] = []
        let url: String = "\(CONST_URL_SECRET)\(EndPoints.heros.rawValue)"
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(heroes)
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        
        let token = KeyChainKc().loadKC(key: CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJwt = token {
            request.addValue("Bearer \(tokenJwt)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response as? HTTPURLResponse,
               resp.statusCode == 200 {
                heroeslist = try! JSONDecoder().decode([HeroesModel].self, from: data)
            }
        } catch {
            
            throw AppError.dataNoReceived
        }
        return heroeslist
    }
    
    
}
