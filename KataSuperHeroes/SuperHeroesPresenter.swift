//
//  SuperHeroesPresenter.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 12/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import UIKit

class SuperHeroesPresenter {

    fileprivate weak var ui: SuperHeroesUI?
    fileprivate let getSuperHeroes: GetSuperHeroes

    init(ui: SuperHeroesUI, getSuperHeroes: GetSuperHeroes) {
        self.ui = ui
        self.getSuperHeroes = getSuperHeroes
    }

    func viewDidLoad() {
        ui?.showLoader()
        getSuperHeroes.execute { result in
            self.ui?.hideLoader()
            
            switch result {
            case .success(let superHeroes):
                if superHeroes.isEmpty {
                    self.ui?.showEmptyCase()
                } else {
                    self.ui?.show(items: superHeroes)
                }
            case .failure(_):
                self.ui?.showError()
            }
        }
    }

    func itemWasTapped(_ item: SuperHero) {
        let superHeroDetailViewController = ServiceLocator().provideSuperHeroDetailViewController(item.name)
        ui?.openSuperHeroDetailScreen(superHeroDetailViewController)
    }
}

protocol SuperHeroesUI: class {
    func showLoader()
    func hideLoader()
    func showEmptyCase()
    func show(items: [SuperHero])
    func showError()
    func openSuperHeroDetailScreen(_ superHeroDetailViewController: UIViewController)

}
