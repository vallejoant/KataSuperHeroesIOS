//
//  SuperHeroDetailViewControllerTests.swift
//  KataSuperHeroesTests
//
//  Created by David Vallejo on 30/01/2019.
//  Copyright © 2019 GoKarumi. All rights reserved.
//

import Foundation
import KIF
import Nimble
import UIKit
@testable import KataSuperHeroes

class SuperHeroDetailViewControllerTests: AcceptanceTestCase {
    
    fileprivate let repository = MockSuperHeroesRepository()
    
    func testSuperHeroNameIsShown() {
        let superhero = givenThereAreASuperHero()
        
        openSuperHeroDetailViewController(superhero: superhero.name)
        
        tester().waitForView(withAccessibilityLabel: superhero.name)
    }
    
    func testSuperHeroDescriptionIsShown() {
        let superhero = givenThereAreASuperHero()
        
        openSuperHeroDetailViewController(superhero: superhero.name)
        
        tester().waitForView(withAccessibilityLabel: superhero.description)
    }
    
    func testAvengerIconIsShownIfSuperHeroIsAvenger() {
        let superhero = givenThereAreASuperHero(avenger: true)
        
        openSuperHeroDetailViewController(superhero: superhero.name)
        
        tester().waitForView(withAccessibilityLabel: "Avenger badge")
    }
    
    func testAvengerIconIsHiddenIfSuperHeroIsNotAvenger() {
        let superhero = givenThereAreASuperHero(avenger: false)
        
        openSuperHeroDetailViewController(superhero: superhero.name)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Avenger badge")
    }

    func testProgressBarIsHiddenWhenSuperHeroIsFetched() {
        let superhero = givenThereAreASuperHero()
        
        openSuperHeroDetailViewController(superhero: superhero.name)
        
        tester().waitForAbsenceOfView(withAccessibilityLabel: "Loading")
    }
    
    func testSuperHeroNavitationTitleIsShown() {
        let superhero = givenThereAreASuperHero()
        
        openSuperHeroDetailViewController(superhero: superhero.name)

        let title = rootViewController?.title ?? ""
        expect(title).to(equal(superhero.name))
    }
    
    func testErrorIsShownIfSuperHeroNotFound() {
        _ = givenThereAreASuperHero()
        
        openSuperHeroDetailViewController(superhero: "no")
        
        tester().waitForView(withAccessibilityLabel:"Not found")
    }

    fileprivate func givenThereAreASuperHero(avenger: Bool = false) -> SuperHero {
        let superHero = SuperHero(name: "SuperHero name",
                photo: NSURL(string: "https://i.annihil.us/u/prod/marvel/i/mg/c/60/55b6a28ef24fa.jpg") as URL?,
                isAvenger: avenger, description: "Description: SuperHero name")

        repository.superHeroes = [superHero]
        return superHero
    }
    
    @discardableResult
    fileprivate func openSuperHeroDetailViewController(superhero: String) -> SuperHeroDetailViewController {
        let superHeroDetailViewController = ServiceLocator()
            .provideSuperHeroDetailViewController(superhero) as! SuperHeroDetailViewController
        superHeroDetailViewController.presenter = SuperHeroDetailPresenter(ui: superHeroDetailViewController, superHeroName: superhero, getSuperHeroByName: GetSuperHeroByName(repository: repository))
            
        let rootViewController = UINavigationController()
        rootViewController.viewControllers = [superHeroDetailViewController]
        present(viewController: rootViewController)
        tester().waitForAnimationsToFinish()
        return superHeroDetailViewController
    }
}
