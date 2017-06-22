//
//  ViewController.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/21/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 250)
        let keyboard = CalculatorKeyboard(frame: frame)
        textField.inputView = keyboard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

