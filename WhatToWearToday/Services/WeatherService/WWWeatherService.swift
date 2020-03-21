//
//  WWWeatherService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import MapKit

class WWWeatherService: WeatherService {
    func cityWeather(cityCoordinates coordinates: CLLocationCoordinate2D, completion: @escaping (Result<ForecastModel, Error>) -> Void) {
        APIClient.performRequest(type: ForecastModel.self, withRoute: WeatherEndPoint.cityForecastByCoordinates(coordinates: coordinates)) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let forecastData):
                // Forecast api returns weather every 3hours, which menas 8 values per day
                // We need only one value per day

                var forecast = forecastData
                let itemsAtEvenIndices = forecastData.list.enumerated().compactMap { tuple in
                  tuple.offset.isMultiple(of: 8) ? tuple.element : nil
                }
                forecast.list = itemsAtEvenIndices
                completion(.success(forecast))
            }
        }
    }
}
