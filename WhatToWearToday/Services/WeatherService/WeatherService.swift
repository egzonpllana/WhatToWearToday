//
//  WeatherService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import MapKit

enum WeatherServiceError: String {
    case unknownCity = "City was not recognized by weather provider."
    case noData = "No data for this city from weather provider."
}

extension WeatherServiceError: LocalizedError {
    public var errorDescription: String? {
        return rawValue
    }
}

protocol WeatherService {

    /**
     **Get city Weather**
     * Details:
        - Will return city weather data of type CityDetailsModel
     - Parameters:
        - city: name of the city
     */
    func cityWeather(cityCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping (Result<ForecastModel, Error>) -> Void)
}
