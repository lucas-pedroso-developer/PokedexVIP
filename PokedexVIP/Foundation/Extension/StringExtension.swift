//
//  StringExtension.swift
//  PokedexVIP
//
//  Created by user on 04/05/23.
//

import Foundation

extension String {
    var removeLeadingZeros: String {
        return self.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
    }
}
