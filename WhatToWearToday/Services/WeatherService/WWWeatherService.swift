//
//  WWWeatherService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

class WWWeatherService: WeatherService {
    func cityWeatherToday(cityName city: String, completion: @escaping (Result<CityDetailsModel, Error>) -> Void) {
        APIClient.performRequest(type: ForecastModel.self, withRoute: WeatherEndPoint.cityForecastByName(city: city)) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let forecastData):
                if let weatherToday = forecastData.list.first {
                    let forecastDetails = ForecastModel(list: [weatherToday])
                    let cityDetails = CityDetailsModel(name: city, forecast: forecastDetails)
                    completion(.success(cityDetails))
                } else {
                    completion(.failure(WeatherServiceError.noData))
                }
            }
        }
    }

    func cityWeatherForFiveDays(cityName city: String, completion: @escaping (Result<CityDetailsModel, Error>) -> Void) {
        APIClient.performRequest(type: ForecastModel.self, withRoute: WeatherEndPoint.cityForecastByName(city: city)) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let cityWeather):
                if cityWeather.list.count > 5 {
                    var weatherData = cityWeather
                    weatherData.list = cityWeather.list.enumerated().compactMap{ $0.offset < 3 ? $0.element : nil }
                    let cityDetails = CityDetailsModel(name: city, forecast: weatherData)
                    completion(.success(cityDetails))
                } else {
                    let cityDetails = CityDetailsModel(name: city, forecast: cityWeather)
                    completion(.success(cityDetails))
                }
            }
        }
    }
}
