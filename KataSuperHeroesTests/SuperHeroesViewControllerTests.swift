//
//  SuperHeroesViewControllerTests.swift
//  KataSuperHeroes
//
//  Created by Pedro Vicente Gomez on 13/01/16.
//  Copyright © 2016 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroesViewControllerTests: AcceptanceTestCase {

    fileprivate let repository = MockSuperHeroesRepository()

    func testShowsEmptyCaseIfThereAreNoSuperHeroes() {
        givenThereAreNoSuperHeroes()

        openSuperHeroesViewController()

        tester().waitForView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testHideEmptyCaseIfThereAreSomeSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "¯\\_(ツ)_/¯")
    }
    
    func testHideProgressBarWhenSuperHeroesAreFetched() {
        _ = givenThereAreSomeSuperHeroes()
        
        openSuperHeroesViewController()
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Loading")
    }

    func testNumberOfCellsIsCorrectIfThereAreXSuperHeroes() {
        let numberOfSuperHeroes = 3
        _ = givenThereAreSomeSuperHeroes(numberOfSuperHeroes)
        
        openSuperHeroesViewController()
        
        tester().waitForCell(at: IndexPath(row: (numberOfSuperHeroes - 1), section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView")
    }
    
    func testSuperHeroNameIsShownCorrectly() {
        let numberOfSuperHeroes = 3
        _ = givenThereAreSomeSuperHeroes(numberOfSuperHeroes)
        
        openSuperHeroesViewController()

        for i in 0..<numberOfSuperHeroes {
            let cell = tester().waitForCell(at: IndexPath(row: i, section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView") as! SuperHeroTableViewCell
            expect(cell.nameLabel.text).to(equal("SuperHero - \(i)"))
        }
    }
    
    func testAvengerIconIsShownIfSuperHeroIsAvenger() {
        let numberOfSuperHeroes = 3
        _ = givenThereAreSomeSuperHeroes(numberOfSuperHeroes, avengers: true)
        
        openSuperHeroesViewController()
        
        for i in 0..<numberOfSuperHeroes {
            let cell = tester().waitForCell(at: IndexPath(row: i, section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView") as! SuperHeroTableViewCell
            expect(cell.avengersBadgeImageView.isHidden).to(equal(false))
        }
    }
    
    func testAvengerIconIsHiddenIfSuperHeroIsNotAvenger() {
        let numberOfSuperHeroes = 3
        _ = givenThereAreSomeSuperHeroes(numberOfSuperHeroes, avengers: false)
        
        openSuperHeroesViewController()
        
        for i in 0..<numberOfSuperHeroes {
            let cell = tester().waitForCell(at: IndexPath(row: i, section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView") as! SuperHeroTableViewCell
            expect(cell.avengersBadgeImageView.isHidden).to(equal(true))
        }
    }
    
    func testSuperHeroDetailIsShownWhenSelectingOne() {
        let numberOfSuperHeroes = 1
        let superheroes = givenThereAreSomeSuperHeroes(numberOfSuperHeroes)
        
        openSuperHeroesViewController()
        
        tester().waitForCell(at: IndexPath(row: 0, section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView")
        
        tester().tapRow(at: IndexPath(row: 0, section: 0), inTableViewWithAccessibilityIdentifier: "SuperHeroesTableView")
        
        tester().waitForAnimationsToFinish()

        tester().waitForView(withAccessibilityLabel: "Loading")
        tester().waitForView(withAccessibilityLabel: superheroes[0].name)
    }

//----------------------------------------------------------------

    fileprivate func givenThereAreNoSuperHeroes() {
        _ = givenThereAreSomeSuperHeroes(0)
    }

    fileprivate func givenThereAreSomeSuperHeroes(_ numberOfSuperHeroes: Int = 10,
        avengers: Bool = false) -> [SuperHero] {
        var superHeroes = [SuperHero]()
        for i in 0..<numberOfSuperHeroes {
            let superHero = SuperHero(name: "SuperHero - \(i)",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avengers, description: "Description - \(i)")
            superHeroes.append(superHero)
        }
        repository.superHeroes = superHeroes
        return superHeroes
    }

//----------------------------------------------------------------
    
    @discardableResult
    fileprivate func openSuperHeroesViewController() -> SuperHeroesViewController {
        let superHeroesViewController = ServiceLocator()
            .provideSuperHeroesViewController() as! SuperHeroesViewController
        superHeroesViewController.presenter = SuperHeroesPresenter(ui: superHeroesViewController,
                getSuperHeroes: GetSuperHeroes(repository: repository))
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroesViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
        return superHeroesViewController
    }
}
