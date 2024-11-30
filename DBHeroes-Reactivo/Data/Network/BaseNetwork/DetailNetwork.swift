//
//  DetailNetwork.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation
import KcLibrarySwift1

// MARK: - Protocols

protocol DetailNetworkProtocol {
    func getTransformations(id: String) async throws -> [TransformationModel]
}

// MARK: - Network Implementation

final class DetailNetwork: DetailNetworkProtocol {
    
    func getTransformations(id: String) async throws -> [TransformationModel] {
        var transformationsList: [TransformationModel] = []
        let url: String = "\(CONST_URL_SECRET)\(EndPoints.transformations.rawValue)"
        
        // Request configuration
        var request: URLRequest = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(TransformationModelRequest(id: id))
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
                transformationsList = try JSONDecoder().decode([TransformationModel].self, from: data)
                transformationsList = transformationsList.sorted(by: { $0.name < $1.name })
            }
        } catch {
            throw AppError.dataNoReceived
        }
        
        return transformationsList
    }
}

// MARK: - Fake Network Implementation

final class NetworkDetailFake: DetailNetworkProtocol {
    func getTransformations(id: String) async throws -> [TransformationModel] {
        return getTranformationFromJson()
    }
}

// MARK: - Helpers

func getTranformationFromJson() -> [TransformationModel] {
    if let url = Bundle.main.url(forResource: "Transformations", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([TransformationModel].self, from: data)
            return jsonData
        } catch {
            print("error: \(error)")
        }
    }
    return []
}


