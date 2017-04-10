//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by 夏语诚 on 2017/4/6.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    var blinking = false {
        didSet {
            blinkIfNeeded()
        }
    }
    
    private var canBlink = false
    private var inABlink = false
    
    private struct BlinkRate {
        static let closedDuration: TimeInterval = 0.4
        static let openDuration: TimeInterval = 2.5
    }
    
    private func blinkIfNeeded() {
        if blinking && canBlink && !inABlink {
            faceView.eyesOpen = false
            inABlink = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false) { [weak self] timer in
                    self?.inABlink = false
                    self?.blinkIfNeeded()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canBlink = true
        blinkIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        canBlink = false
    }
    
    override func updateUI() {
        super.updateUI()
        blinking = expression.eyes == .squinting
    }

}
