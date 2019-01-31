//
//  GetSuperHeroes.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 12/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import Result

class GetSuperHeroes {

    fileprivate let repository: SuperHeroesRepository

    init(repository: SuperHeroesRepository) {
        self.repository = repository
    }

    func execute(_ completion: @escaping (Result<[SuperHero], SuperHeroAPIError>) -> ()) {
        repository.getAll() { result in
            completion(result)
        }
    }
}
