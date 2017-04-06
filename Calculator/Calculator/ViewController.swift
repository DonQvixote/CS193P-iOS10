//
//  ViewController.swift
//  Calculator
//
//  Created by 夏语诚 on 2017/3/9.
//  Copyright © 2017年 Banana Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false
 
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }

    @IBOutlet weak var display: UILabel!
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }

    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
    
    private func showSizeClasses() {
        if !userIsInTheMiddleOfTyping {
            display.textAlignment = .center
            display.text = "width " + traitCollection.horizontalSizeClass.description + " height " + traitCollection.verticalSizeClass.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅") { [weak self] in
            self?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSizeClasses()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { coordinator in
            self.showSizeClasses()
        }, completion: nil)
    }
}

extension UIUserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compact:
            return "Compact"
        case .regular:
            return "Regular"
        case .unspecified:
            return "??"
        }
    }
}
