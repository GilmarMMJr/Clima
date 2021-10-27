//
//  weatherData.swift
//  Clima
//
//  Created by Gilmar Junior on 20/10/21.
//

import Foundation

struct WeatherData: Codable{
    
    let name: String
    let weather: [Weather]
    let main : Main
}

struct Weather: Codable {
    let id: Int
    let description: String
}

struct Main: Codable {
    let temp: Double
}
