//
//  DetailNetwork.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation
import KcLibrarySwift1

protocol DetailNetworkProtocol {
    func getTransformations(id: String) async throws -> [TransformationModel]
}


final class DetailNetwork: DetailNetworkProtocol {
  
    func getTransformations(id: String) async throws -> [TransformationModel] {
        var transformationsList: [TransformationModel] = []
        let url: String = "\(CONST_URL_SECRET)\(EndPoints.transformations.rawValue)"
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(TransformationModelRequest(id: id))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-Type")
        
        let token = KeyChainKc().loadKC(key: CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJwt = token {
            request.addValue("Bearer \(tokenJwt)", forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response as? HTTPURLResponse,
               resp.statusCode == 200 {
                transformationsList = try! JSONDecoder().decode([TransformationModel].self, from: data)
                transformationsList = transformationsList.sorted(by: { $0.name < $1.name })
            }
        } catch {
            
            throw AppError.dataNoReceived
        }
        return transformationsList
    }
    
}




