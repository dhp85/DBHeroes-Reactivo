//
//  AppError.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 25/11/24.
//

import Foundation

enum AppError: Error {
    
    case nodata
    case badURL
    case errorFromApi(statusCode: Int)
    case dataNoReceived
    case notConversionString
    case errorTokenMissing
    
}

