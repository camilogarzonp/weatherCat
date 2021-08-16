//
//  Helpers.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import Foundation

extension String {
    
    /// Assignable to strings to change trailing spaces and line breaks to single spaces
    /// - Returns: Returns the same string with single spaces
    func removeExtraSpaces() -> String{
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    /// Assignable to strings to change single spaces to spaces +
    /// - Returns: Returns the same string separated each word with +
    func changeSpacesForPlus() -> String{
        return self.replacingOccurrences(of: " ", with: "+", options: .regularExpression, range: nil)
    }
}
