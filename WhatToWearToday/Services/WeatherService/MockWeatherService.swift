//
//  MockWeatherService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import MapKit

class MockWeatherService: WeatherService {
    func cityWeather(cityCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        completion(.success(ForecastModelStubModel))
    }
}
