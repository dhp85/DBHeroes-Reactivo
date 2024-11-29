//
//  LoginNetwork.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//
import Foundation

protocol LoginNetworkprotocol {
    func login(username: String, password: String) async throws -> String
}


final class LoginNetwork: LoginNetworkprotocol {
    func login(username: String, password: String) async throws -> String {
        
        var token: String = ""
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8)?.base64EncodedString() else { throw AppError.notConversionString }
        
        let stringUrl = "\(CONST_URL_SECRET)\(EndPoints.login.rawValue)"
        
        var request = URLRequest(url: URL(string: stringUrl)!)
        request.httpMethod = HTTPMethods.post
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        request.addValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let resp = response as? HTTPURLResponse
                // Verificar si el código de estado es 200
            if resp?.statusCode == 200 {
                    token = String(decoding: data, as: UTF8.self)
                }
           } catch {
            throw AppError.errorTokenMissing
        }
        
        return token
    }
    
}

final class NetworkLoginFake: LoginNetworkprotocol {
    func login(username: String, password: String) async throws -> String {
        return UUID().uuidString
    }
}
