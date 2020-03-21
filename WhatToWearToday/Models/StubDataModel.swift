//
//  StubDataModel.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

// PlaceMark
let placeMarkStubData = PlaceMark(country: "Kosovo", address: "Prishtina", suburb: "Rr.Isa Kastrati", state: "Kosovo", postcode: "10000", coordinates: (-23.0558714, 23.7461693))

// WeatherModels

let ForecastModelStubModel = ForecastModel(list: [weatherModelStubMobel, weatherModelStubMobel, weatherModelStubMobel, weatherModelStubMobel, weatherModelStubMobel], city: cityModelStubModel)
let cityModelStubModel = CityModel(name: "Prishtina")
let weatherModelStubMobel = WeatherModel(main: dayWeatherModelStubModel, dayTimeStamp: 1584824400)
let dayWeatherModelStubModel = DayWeatherModel(temp: 27, feelsLike: 25)
