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
        request.httpBody = try? JSONEncoder().encode(HeroModelRequest(name: heroes))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-Type")
        
        let token = KeyChainKc().loadKC(key: CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJwt = token {
            request.addValue("Bearer \(tokenJwt)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response as? HTTPURLResponse,
               resp.statusCode == 200 {
                heroeslist = try! JSONDecoder().decode([HeroesModel].self, from: data)
                heroeslist = heroeslist.sorted(by: { $0.name < $1.name })
            }
        } catch {
            
            throw AppError.dataNoReceived
        }
        return heroeslist
    }
        
}

final class NetworkHerosFake: HeroesNetworkProtocol {
    func getHeroes(heroes: String) async throws -> [HeroesModel] {
        return getHerosFromJson()
    }
}

func getHerosFromJson() -> [HeroesModel] {
    if let url = Bundle.main.url(forResource: "heroes", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([HeroesModel].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return []
}

func getHerosHardcoded() -> [HeroesModel] {
    let model1 = HeroesModel(favorite: true,
                            description: "Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.",
                             id: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94",
                            name: "Goku",photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300")

   let model2 = HeroesModel(favorite: true,
                           description: "Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.",id: "6E1B907C-EB3A-45BA-AE03-44FA251F64E9",
                            name: "Vegeta",
                           photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300")

   return [model1, model2]
}
