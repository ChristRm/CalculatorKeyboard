//
//  NumberFormatter.swift
//  CalculatorKeyboard
//
//  Created by Chris Rusin on 6/24/17.
//  Copyright © 2017 Chris Rusin. All rights reserved.
//

import Foundation

extension NumberFormatter {
    static func formatterWithSeparator(_ separator: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        return formatter
    }
}
