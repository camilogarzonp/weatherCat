//
//  Helpers.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import Foundation

extension String {
    func removeExtraSpaces() -> String{
        return self.replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)
    }
    
    func changeSpacesForPlus() -> String{
        return self.replacingOccurrences(of: " ", with: "+", options: .regularExpression, range: nil)
    }
}
