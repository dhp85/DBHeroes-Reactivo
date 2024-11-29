//
//  DetailUseCaseProtocol.swift
//  DBHeroes-Reactivo
//
//  Created by Diego Herreros Parron on 27/11/24.
//

import Foundation

protocol DetailUseCaseProtocol {
    var repo: DetailHeroesRepositoryProtocol { get set }
    func gettransformations(id:String) async throws -> [TransformationModel]
}
