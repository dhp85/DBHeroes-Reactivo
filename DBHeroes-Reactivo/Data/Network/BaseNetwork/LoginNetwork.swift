//
//  LoginNetwork.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//
import Foundation

// MARK: - Protocols

protocol LoginNetworkProtocol {
    func login(username: String, password: String) async throws -> String
}

// MARK: - Network Implementation

final class LoginNetwork: LoginNetworkProtocol {
    func login(username: String, password: String) async throws -> String {
        var token: String = ""
        
        // Prepare login credentials
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8)?.base64EncodedString() else {
            throw AppError.notConversionString
        }
        
        // Configure URL and request
        let stringUrl = "\(CONST_URL_SECRET)\(EndPoints.login.rawValue)"
        var request = URLRequest(url: URL(string: stringUrl)!)
        request.httpMethod = HTTPMethods.post
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type")
        request.addValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        
        // Perform network call
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            let resp = response as? HTTPURLResponse
            
            // Check status code
            if resp?.statusCode == 200 {
                token = String(decoding: data, as: UTF8.self)
            }
        } catch {
            throw AppError.errorTokenMissing
        }
        
        return token
    }
}

// MARK: - Fake Network Implementation

final class NetworkLoginFake: LoginNetworkProtocol {
    func login(username: String, password: String) async throws -> String {
        return UUID().uuidString
    }
}
