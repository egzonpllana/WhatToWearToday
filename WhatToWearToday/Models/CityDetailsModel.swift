//
//  CityDetailsModel.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

struct CityDetailsModel: Codable {
    let name: String
    let forecast: [WeatherModel]
}
