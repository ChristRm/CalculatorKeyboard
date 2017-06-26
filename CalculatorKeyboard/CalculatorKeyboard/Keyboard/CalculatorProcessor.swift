//
//  CalculatorProcessor.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/23/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import Foundation

class CalculatorProcessor: CalculatorProcessing {
    enum Defaults {
        static let enabledCharactersSet = CharacterSet(charactersIn: "0123456789+-*/.")
        static let roundPrecission: Double = 10000
    }
    
    // MARK: - CalculatorProcessing
    
    fileprivate(set) var output: String = ""
    var canBeEvaluated: Bool {
        let operatorsSet = CharacterSet(charactersIn: "+-*/")
        let numbersMatches = getAllNumbers(output)
        return output.rangeOfCharacter(from: operatorsSet) != nil && numbersMatches.count > 1
    }
    
    func setExpression(_ expression: String) {
        output = expression
        if expression.isEmpty {
            setResult(0.0)
        } else {
            formatExpression()
        }
    }
    
    func evaluateExpression(_ invalidate: Bool) -> Bool {
        var valid = false
        let expressionToEvaluate = output.replacingOccurrences(of: ",", with: "")
        if isExpressionValid(expressionToEvaluate) {
            do {
                let result = try expressionToEvaluate.evaluate()
                setResult(result)
                valid = true
            } catch {
                valid = false
            }
        } else {
            valid = false
        }
        
        if invalidate && !valid {
            setResult(0.0)
        }
        
        return valid
    }
    
    // MARK: - Private methods
    
    fileprivate func setResult(_ result: Double) {
        let roundedResult = Double(round(Defaults.roundPrecission*result)/Defaults.roundPrecission)
        
        let isInteger = roundedResult.truncatingRemainder(dividingBy: 1) == 0
        
        if isInteger {
            output = String(Int(roundedResult))
        } else {
            output = String(roundedResult)
        }
        formatExpression()
    }
    
    fileprivate func isExpressionValid(_ expression: String) -> Bool {
        return expression.rangeOfCharacter(from: Defaults.enabledCharactersSet.inverted) == nil
    }
    
    // MARK - formatting expression
    
    fileprivate func formatExpression() {
        output = output.replacingOccurrences(of: ",", with: "")
        output = formatOperators(output)
        output = formatNumbers(output, with: ",")
    }
    
    fileprivate func formatOperators(_ expression: String) -> String {
        var resultExpression = expression
        do {
            let operatorsTogetherFindExpression = try NSRegularExpression(pattern: "([*/+-]{2,})", options: [])
            if let match = operatorsTogetherFindExpression.matches(in: expression, options: [],
                                                                   range: NSRange(location: 0, length: expression.characters.count)).last {
                let matchedRange = match.range
                let nsResultExpression = resultExpression as NSString
                let operators = nsResultExpression.substring(with: matchedRange)
                if let lastOperator = operators.characters.last {
                    resultExpression = nsResultExpression.replacingCharacters(in: matchedRange, with: String(lastOperator))
                }
            }
        } catch { }
        
        return resultExpression
    }
    
    fileprivate func formatNumbers(_ expression: String, with separator: String) -> String {
        var resultExpression = expression
        
        let numberMatches = getAllNumbers(expression)
        numberMatches.forEach {
            var numberRange = $0.range
            numberRange.location = numberRange.location + resultExpression.characters.count - expression.characters.count
            
            var nsStringResultExpression = resultExpression as NSString
            let matchedSting = nsStringResultExpression.substring(with: numberRange) as NSString
            
            var intPartRange = numberRange
            var intPartString = matchedSting
            var floatPartRange = NSRange()
            
            let firstPointRange = matchedSting.range(of: ".")
            
            if firstPointRange.location != NSNotFound {
                if firstPointRange.location == 0 {
                    resultExpression = nsStringResultExpression.replacingCharacters(in: intPartRange, with: "0.")
                } else {
                    intPartRange.length = firstPointRange.location
                    intPartString = nsStringResultExpression.substring(with: intPartRange) as NSString
                    
                    floatPartRange.location = intPartRange.location + firstPointRange.location + firstPointRange.length
                    floatPartRange.length = numberRange.location + numberRange.length - floatPartRange.location
                }
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.maximumIntegerDigits = 100
            
            if let number = numberFormatter.number(from: intPartString as String) {
                if let formattedNumber = NumberFormatter.formatterWithSeparator(separator).string(from: number) {
                    nsStringResultExpression = nsStringResultExpression.replacingOccurrences(of: ".", with: "", options: [],
                                                                                             range: floatPartRange) as NSString
                    resultExpression = nsStringResultExpression.replacingCharacters(in: intPartRange, with: formattedNumber)
                }
            }
        }
        
        return resultExpression
    }
    
    fileprivate func getAllNumbers(_ expression: String) -> [NSTextCheckingResult] {
        do {
            let numberFindExpression = try NSRegularExpression(pattern: "(([0-9.,]+))", options: [])
            return numberFindExpression.matches(in: expression, options: [], range: NSRange(location: 0, length: expression.characters.count))
        } catch { }
        return []
    }
}
