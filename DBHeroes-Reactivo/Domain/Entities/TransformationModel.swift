//
//  TransformationModel.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation

struct TransformationModel: Codable {
    let name, id: String
        let photo: String?
        let description: String
        
}

struct TransformationModelRequest: Codable {
    let id: String
}
