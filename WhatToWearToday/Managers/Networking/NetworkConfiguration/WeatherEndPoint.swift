//
//  WeatherEndPoint.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

private let privateAPIKey: String = "29dde7503518239f63624f7eb82e9e6d"

enum WeatherEndPoint: APIConfiguration {
    case cityForecastByName(city: String)
    case cityForecastByCoordinates(coordinates: CLLocationCoordinate2D)
}

extension WeatherEndPoint {
    var path: String {
        switch self {
            // /forecast?q=California&appid=29dde7503518239f63624f7eb82e9e6d
        case .cityForecastByName(let city):
            return "forecast?q=\(city)&appid=\(privateAPIKey)"
        case .cityForecastByCoordinates(let coordinates):
            return "weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(privateAPIKey)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .cityForecastByName, .cityForecastByCoordinates: return .get
        }
    }

    var parameters: Parameters? {
        switch self {
        case .cityForecastByName, .cityForecastByCoordinates: return nil
        }
    }

}
