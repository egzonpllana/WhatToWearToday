//
//  AppDependency.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
class AppDependency: CoreDependency {

    // MARK: - StorageService
    override func locationService() -> LocationService {
        return WWLocationService(googleAPIKey: "AIzaSyB3XaZORxNCyRShZy01-AdfaUwPdX41Y1Q")
    }

    // MARK: - WeatherService
    override func weatherService() -> WeatherService {
        return WWWeatherService()
    }
}
