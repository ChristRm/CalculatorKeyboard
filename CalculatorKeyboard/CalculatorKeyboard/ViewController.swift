//
//  ViewController.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/21/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CalculatorKeyboardDelegate {
    
    // MARK: - Properties
    
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet weak var otherTextField: UITextField!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        let calculatorKeyboard = CalculatorKeyboard(frame: frame, processor: CalculatorProcessor())
        calculatorKeyboard.delegate = self
        
        textField.inputView = calculatorKeyboard
        textField.delegate = calculatorKeyboard
        
        otherTextField.inputView = calculatorKeyboard
        otherTextField.delegate = calculatorKeyboard
    }
    
    // MARK: - CalculatorKeyboardDelegate

    func calculatorKeyboardDidCalculate(_ calculatorKeyboard: CalculatorKeyboard) {
        //handle success calculation(alert etc.)
        calculatorKeyboard.currentTextField?.textColor = UIColor.black
    }
    
    func calculatorKeyboardDidFailCalculate(_ calculatorKeyboard: CalculatorKeyboard) {
        //handle fail calculation(alert etc.)
        calculatorKeyboard.currentTextField?.textColor = UIColor.red
    }
}
