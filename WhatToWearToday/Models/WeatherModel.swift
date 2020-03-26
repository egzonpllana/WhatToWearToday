//
//  WeatherModel.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

// API data models structure:
// Response -> { list: [ main: { temp: Double, feels_like: Double } ]

struct ForecastModel: Codable {
    var list: [WeatherModel]
    let city: CityModel
}

struct CityModel: Codable {
    let name: String
}

struct WeatherModel: Codable {
    let main: DayWeatherModel?
    let dayTimeStamp: Int?

    enum CodingKeys: String, CodingKey {
        case main, dayTimeStamp = "dt"
    }
}

struct DayWeatherModel: Codable {
    let temp: Double
    let feelsLike: Double

    enum CodingKeys: String, CodingKey {
        case temp, feelsLike = "feels_like"
    }
}

extension DayWeatherModel {
    var tempToCelsius: Double {
        return round(Double((temp - 273.15)))
    }

    var feelsLikeToCelsius: Double {
        return round(Double((feelsLike - 273.15)))
    }
}
