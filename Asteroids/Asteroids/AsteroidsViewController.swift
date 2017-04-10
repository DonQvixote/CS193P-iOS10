//
//  ViewController.swift
//  Asteroids
//
//  Created by 夏语诚 on 2017/4/10.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class AsteroidsViewController: UIViewController {

    private var asteroidField: AsteroidFieldView!
    private var ship: SpaceshipView!
    
    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.asteroidField)
    
    private var asteroidBehavior = AsteroidBehavior()
    
    
    @IBAction func burn(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            ship.direction = (sender.location(in: view) - ship.center).angle
            burn()
        case .ended:
            endBurn()
        default:
            break
        }
    }
    
    private func burn() {
        ship.enginesAreFiring = true
        asteroidBehavior.acceleration.angle = ship.direction - CGFloat.pi
        asteroidBehavior.acceleration.magnitude = Constants.burnAcceleration
    }
    
    private func endBurn() {
        ship.enginesAreFiring = false
        asteroidBehavior.acceleration.magnitude = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeIfNeeded()
        animator.addBehavior(asteroidBehavior)
        asteroidBehavior.pushAllAsteroids()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animator.removeBehavior(asteroidBehavior)
    }
    
    private func initializeIfNeeded() {
        if asteroidField == nil {
            asteroidField = AsteroidFieldView(frame: CGRect(center: view.bounds.mid, size: view.bounds.size * Constants.asteroidFieldMagnitude))
            view.addSubview(asteroidField)
            
            let shipSize = view.bounds.size.minEdge * Constants.shipSizeToMinBoundsEdgeRatio
            ship = SpaceshipView(frame: CGRect(squareCenteredAt: asteroidField.center, size: shipSize))
            view.addSubview(ship)
            repositionShip()
            
            asteroidField.addAsteroids(count: Constants.initialAsteroidCount, exclusionZone: ship.convert(ship.bounds, to: asteroidField))
            asteroidField.asteroidBehavior = asteroidBehavior
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        asteroidField?.center = view.bounds.mid
        repositionShip()
    }
    
    private func repositionShip() {
        if asteroidField != nil {
            ship.center = asteroidField.center
            asteroidBehavior.setBoundary(ship.shieldBoundary(in: asteroidField), named: Constants.shipBoundaryName) {
                [weak self] in
                if let ship = self?.ship {
                    if !ship.shieldIsActive{
                        ship.shieldIsActive = true
                        ship.shieldLevel -= Constants.Shield.activationCost
                        Timer.scheduledTimer(withTimeInterval: Constants.Shield.duration, repeats: false) { timer in
                            ship.shieldIsActive = false
                            if ship.shieldLevel == 0 {
                                ship.shieldLevel = 100
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Constants
    private struct Constants {
        static let initialAsteroidCount = 20
        static let shipBoundaryName = "Ship"
        static let shipSizeToMinBoundsEdgeRatio: CGFloat = 1/5
        static let asteroidFieldMagnitude: CGFloat = 10  // as a multiple of view.bounds.size
        static let burnAcceleration: CGFloat = 0.07  // points/s/s
        struct Shield {
            static let duration: TimeInterval = 1.0  // how long shield stays up
            static let activationCost: Double = 15   // per activation
        }
    }


}

