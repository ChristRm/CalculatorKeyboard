//
//  CalculatorKeyboard.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/21/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import UIKit

protocol CalculatorKeyboardDelegate: class {
    func calculatorKeyboard(_ calculatorKeyboard: CalculatorKeyboard, didChange output: String)
    func calculatorKeyboardDidFail(_ calculatorKeyboard: CalculatorKeyboard)
}

class CalculatorKeyboard: UIView, UITextFieldDelegate {
    enum CalculatorKey: Int {
        case zero
        case one
        case two
        case three
        case four
        case five
        case six
        case seven
        case eight
        case nine
        case threeZeros
        case decimal
        case equal
        case add
        case subtract
        case delete
        case multiply
        case divide
        case clear
    }
    
    // MARK: - Properties
    let expressionEvaluator = ExpressionEvaluator()
    
    weak var delegate: CalculatorKeyboardDelegate?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    fileprivate func commonInit() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view ?? UIView()
    }
    
    @IBAction fileprivate func buttonTouched(_ sender: Any) {
        if let button = sender as? UIButton {
            switch button.tag {
            case CalculatorKey.delete.rawValue:
                expressionEvaluator.removeLastCharacter()
                break
                
            case CalculatorKey.clear.rawValue:
                //expressionEvaluator.
                break
                
            case CalculatorKey.equal.rawValue:
                let success = expressionEvaluator.evaluateExpression()
                print("success \(success)")
                break
                
            default:
                if let text = button.titleLabel?.text {
                    expressionEvaluator.addInput(text)
                }
                break
            }            
        }
        
        delegate?.calculatorKeyboard(self, didChange: expressionEvaluator.expression)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        expressionEvaluator.expression = string
        return true
    }
}
