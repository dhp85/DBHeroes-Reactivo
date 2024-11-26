//
//  AppError.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation

enum AppError: Error, CustomStringConvertible {
    
    case nodata
    case badURL
    case errorFromApi(statusCode: Int)
    case dataNoReceived
    case notConversionString
    case errorTokenMissing
    
    var description: String {
        switch self {
        case .nodata:
            return "No data received"
        case .badURL:
            return "Bad URL"
        case .errorFromApi(statusCode: let statusCode):
            return "Error from API: \(statusCode)"
        case .dataNoReceived:
            return "Data not received"
        case .notConversionString:
            return "Not conversion string"
        case .errorTokenMissing:
            return "Token missing"
        }
    }
}

