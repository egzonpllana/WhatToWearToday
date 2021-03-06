//
//  CoreDependency.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit

protocol Dependency {
    func locationService() -> LocationService
    func weatherService() -> WeatherService
}

class CoreDependency: Dependency {
    func locationService() -> LocationService {
        return MockLocationService()
    }

    func weatherService() -> WeatherService {
        return MockWeatherService()
    }
}
