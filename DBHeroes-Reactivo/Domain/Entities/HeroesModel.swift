//
//  HeroesModel.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 26/11/24.
//

import Foundation

struct HeroesModel: Codable {
    let favorite: Bool
    let description, id, name: String
    let photo: String?
}

struct HeroModelRequest: Codable {
    let name: String
}
