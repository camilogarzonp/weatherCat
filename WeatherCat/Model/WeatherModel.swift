//
//  WeatherModel.swift
//  WeatherCat
//
//  Created by Juan Camilo Garzón Patiño on 15/08/21.
//

import Foundation

struct WeatherAPI: Codable {
    let weather : [WeatherDic]
    let main : MainDic
    let wind : WindDic
    let timezone : Int
    let name : String
    let cod : Int16
}

struct WeatherDic: Codable {
    let main : String
    let description : String
}

struct MainDic: Codable {
    let temp : Double
    let feels_like : Double
    let temp_min : Double
    let temp_max : Double
}

struct WindDic: Codable {
    let speed : Double
}
