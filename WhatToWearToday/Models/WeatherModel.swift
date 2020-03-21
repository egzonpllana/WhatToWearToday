//
//  WeatherModel.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

struct ForecastModel: Codable {
    var list: [WeatherModel]

    enum CodingKeys: String, CodingKey {
        case list
    }
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
