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

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        let calculatorKeyboard = CalculatorKeyboard(frame: frame)
        calculatorKeyboard.delegate = self
        
        textField.inputView = calculatorKeyboard
        textField.delegate = calculatorKeyboard
        
        //calculatorKeyboard.de
    }
    
    // MARK: - CalculatorKeyboardDelegate
    
    func calculatorKeyboard(_ calculatorKeyboard: CalculatorKeyboard, didChange output: String) {
        textField.text = output
    }
    
    func calculatorKeyboardDidFail(_ calculatorKeyboard: CalculatorKeyboard) {
        textField.textColor = UIColor.red
    }
}
