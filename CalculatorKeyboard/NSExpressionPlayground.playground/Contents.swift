//: Playground - noun: a place where people can play

import UIKit

struct Number {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "," // or possibly "." / ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
extension Integer {
    var stringWithSepator: String {
        return Number.withSeparator.string(from: NSNumber(value: hashValue)) ?? ""
    }
}

var expressionString = "13123.0123 + 12312312 - 8934957279479379239759783297597023790825349"
var nsExpressionString = expressionString as NSString

let regExp = try NSRegularExpression(pattern: "(([0-9.]+))", options: [])
regExp.matches(in: expressionString, options: [], range: NSRange(location: 0, length: expressionString.characters.count)).forEach {
    
    let numberString = nsExpressionString.substring(with: $0.range)
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    
    let number = numberFormatter.number(from: numberString)
    if let formattedNumber = Number.withSeparator.string(from: number as! NSNumber) {
        expressionString = expressionString.replacingOccurrences(of: numberString, with: formattedNumber)
    }
}

print(expressionString)

//NSMutableArray *expressionTokens = [[NSMutableArray alloc] init];
//
//char character = (char)0;
//int numberStartIndex = -1;
//OperatorToken *operatorToken = nil;
//NumberToken *numberToken = nil;
//BOOL lastCharacter = NO;

//for (int i = 0; i < [_expressionString length]; i++) {
//    lastCharacter = i == [_expressionString length] - 1;
//    character = [_expressionString characterAtIndex : i];
//    
//    numberToken = nil;
//    operatorToken = nil;
//    
//    if ([self isNumber: character]) {//if () isNumber if number start index is -1 then assign number start index to i
//        if (lastCharacter) {
//            if (numberStartIndex == -1) {
//                numberToken = [self createNumberTokenFromString : _expressionString withRangeFrom : i to : 1];
//            }
//            else {
//                numberToken = [self createNumberTokenFromString : _expressionString withRangeFrom : numberStartIndex to : i - numberStartIndex + 1];
//                numberStartIndex = -1;
//            }
//        }
//        
//        if (numberStartIndex == -1) {
//            numberStartIndex = i;
//        }
//        
//        if (numberToken) {
//            [expressionTokens addObject : numberToken];
//        }
//        
//        continue;
//    } else if (numberStartIndex != -1) {
//        numberToken = [self createNumberTokenFromString : _expressionString withRangeFrom : numberStartIndex to : i - numberStartIndex];
//        
//        numberStartIndex = -1;
//        
//        if (numberToken)
//        [expressionTokens addObject : numberToken];
//    }
//    
//    switch (character) {
//    case '*':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_Multiply];
//        break;
//        
//    case ':':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_Devide];
//        break;
//        
//    case '+':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_Add];
//        break;
//        
//    case '-':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_Substract];
//        break;
//        
//    case '/':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_RationalDevide];
//        break;
//        
//    case '(':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_OpenScope];
//        break;
//        
//    case ')':
//        operatorToken = [[OperatorToken alloc] initWithOperatorType : OT_CloseScope];
//        break;
//        
//    case ' ':
//        break;
//        
//    default:
//        _lastError = ER_IncorrectExpression;
//        return nil;
//    }
//    
//    if (operatorToken) {
//        [expressionTokens addObject: operatorToken];
//    }
//}
//
//[self createRationalTokens: expressionTokens];
//
//return expressionTokens;
//}
