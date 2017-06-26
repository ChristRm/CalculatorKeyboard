//
//  CalculatorKeyboard.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/21/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import UIKit

protocol CalculatorProcessing {
    var output: String { get }
    var canBeEvaluated: Bool { get }
    
    func setExpression(_ expression: String)
    
    func evaluateExpression(_ invalidate: Bool) -> Bool
}

protocol CalculatorKeyboardDelegate: class {
     func calculatorKeyboardDidCalculate(_ calculatorKeyboard: CalculatorKeyboard)
     func calculatorKeyboardDidFailCalculate(_ calculatorKeyboard: CalculatorKeyboard)
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
    
    weak var delegate: CalculatorKeyboardDelegate?
    
    fileprivate(set) weak var currentTextField: UITextField?
    var processor: CalculatorProcessing?
    
    //MARK: - IBOutlets
    @IBOutlet fileprivate weak var equalButton: UIButton!
    
    // MARK: - Inits
    
    init(frame: CGRect, processor: CalculatorProcessing) {
        self.processor = processor
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    //MARK: - IBAction
    
    @IBAction fileprivate func buttonTouched(_ sender: Any) {
        if let button = sender as? UIButton {
            switch button.tag {
            case CalculatorKey.delete.rawValue:
                currentTextField?.deleteBackward()
                break
                
            case CalculatorKey.clear.rawValue:
                currentTextField?.text = ""
                break
                
            case CalculatorKey.equal.rawValue:
                returnPressed()
                break
                
            default:
                if let text = button.titleLabel?.text {
                    currentTextField?.insertText(text)
                }
                break
            }
            
            guard let processor = processor else { return }
            
            processor.setExpression(convertSymbolsForProcessor(currentTextField?.text ?? ""))
            currentTextField?.text = convertSymbolsFromProcessor(processor.output)
            updateEqualButton()
        }
    }
    
    fileprivate func updateEqualButton() {
        guard let processor = processor else { return }
        
        let title = processor.canBeEvaluated ? "=" : "Ready"
        equalButton.setTitle(title, for: .normal)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalculatorKeyboard", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view ?? UIView()
    }
    
    fileprivate func returnPressed() {
        guard let processor = processor else { currentTextField?.endEditing(true); return }
        
        if processor.canBeEvaluated {
            evaluateExpression(false)
        } else {
            currentTextField?.endEditing(true)
        }
    }
    
    fileprivate func evaluateExpression(_ invalidate: Bool) {
        guard let processor = processor else { return }
        
        let success = processor.evaluateExpression(invalidate)
        if success {
            delegate?.calculatorKeyboardDidCalculate(self)
        } else {
            delegate?.calculatorKeyboardDidFailCalculate(self)
        }
        
        currentTextField?.text = processor.output
    }
    
    fileprivate func convertSymbolsForProcessor(_ inputString: String) -> String {
        var result = inputString
        result = result.replacingOccurrences(of: "÷", with: "/")
        result = result.replacingOccurrences(of: "×", with: "*")
        result = result.replacingOccurrences(of: "−", with: "-")
        return result
    }
    
    fileprivate func convertSymbolsFromProcessor(_ outputString: String) -> String {
        var result = outputString
        result = result.replacingOccurrences(of: "/", with: "÷")
        result = result.replacingOccurrences(of: "*", with: "×")
        result = result.replacingOccurrences(of: "-", with: "−")
        return result
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        
        guard let processor = processor else { return }
        processor.setExpression(convertSymbolsForProcessor(textField.text ?? ""))
        updateEqualButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        evaluateExpression(true)
        currentTextField = nil
        
        guard let processor = processor else { return }
        processor.setExpression("")
    }
}
