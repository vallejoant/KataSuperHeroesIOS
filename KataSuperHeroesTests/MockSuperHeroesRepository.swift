//
//  MockSuperHeroesRepository.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import Result

@testable import KataSuperHeroes

class MockSuperHeroesRepository: SuperHeroesRepository {

    var superHeroes = [SuperHero]()

    override func getAll(_ completion: @escaping (Result<[SuperHero], SuperHeroAPIError>) -> ()) {
        completion(.success(superHeroes))
    }

    override func getSuperHero(withName name: String, completion: @escaping (SuperHero?) -> ()) {
        let superHeroByName = superHeroes.filter { $0.name == name }.first
        completion(superHeroByName)
    }

}
