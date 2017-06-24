//
//  ExpressionEvaluator.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/23/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import Foundation

class ExpressionEvaluator {
    var expression: String = ""
    
    func addInput(_ input: String) {
        expression.append(input)
        //separateByComma()
    }
    
    func removeLastCharacter() {
        let truncated = expression.substring(to: expression.index(before: expression.endIndex))
        expression = truncated
        separateByComma()
    }
    
    func evaluateExpression() -> Bool {
        if isExpressionValid {
            do {
                let nonSeparatedNumbersExpression = convertNumbersToSeparatedBy(expression: expression, separator: "")
                let result = try nonSeparatedNumbersExpression.evaluate()
                print("result \(result)")
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    fileprivate func isOperator(_ string: String) -> Bool {
        guard string.characters.count == 1 else { return false }
        
        var enabledCharactersSet = CharacterSet(charactersIn: "+-*/")
        enabledCharactersSet.invert()
        
        return expression.rangeOfCharacter(from: enabledCharactersSet) == nil
    }
    
    fileprivate var isExpressionValid: Bool {
        var enabledCharactersSet = CharacterSet(charactersIn: "0123456789+-*/.")
        enabledCharactersSet.invert()
        
        return expression.rangeOfCharacter(from: enabledCharactersSet) == nil
    }
    
    fileprivate func separateByComma() {
        expression = expression.replacingOccurrences(of: ",", with: "")
        expression = convertNumbersToSeparatedBy(expression: expression, separator: ",")
    }
    
    fileprivate func convertNumbersToSeparatedBy(expression: String, separator: String) -> String {
        var resultExpression = expression
        let nsExpressionString = expression as NSString
        do {
            let regExp = try NSRegularExpression(pattern: "(([0-9.,]+))", options: [])
            regExp.matches(in: resultExpression, options: [], range: NSRange(location: 0, length: expression.characters.count)).forEach {
                let numberString = nsExpressionString.substring(with: $0.range)
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                if let number = numberFormatter.number(from: numberString) {
                    if let formattedNumber = NumberFormatter.formatterWithSeparator(separator).string(from: number) {
                        resultExpression = resultExpression.replacingOccurrences(of: numberString, with: formattedNumber)
                    }
                }
            }
        } catch { }
        return resultExpression
    }
}
