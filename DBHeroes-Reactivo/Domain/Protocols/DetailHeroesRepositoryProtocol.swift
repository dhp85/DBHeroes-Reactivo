//
//  DetailHeroesRepositoryProtocol.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation

protocol DetailHeroesRepositoryProtocol {
    func gettransformations(id: String) async throws -> [TransformationModel]
}
