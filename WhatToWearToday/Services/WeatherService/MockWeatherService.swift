//
//  MockWeatherService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

class MockWeatherService: WeatherService {
    func cityWeatherToday(cityName city: String, completion: @escaping (Result<CityDetailsModel, Error>) -> Void) {
        let cityDetails = CityDetailsModel(name: city, forecast: ForecastModelStubModel)
        completion(.success(cityDetails))
    }

    func cityWeatherForFiveDays(cityName city: String, completion: @escaping (Result<CityDetailsModel, Error>) -> Void) {
        let cityDetails = CityDetailsModel(name: city, forecast: ForecastModelStubModel)
        completion(.success(cityDetails))
    }
}
