//
//  StubDataModel.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

// PlaceMark
let placeMarkStubData = PlaceMark(country: "Kosovo", address: "Pristina", suburb: "Rr.Isa Kastrati", state: "Kosovo", postcode: "10000", coordinates: (-23.0558714, 23.7461693))

// WeatherModels

let ForecastModelStubModel = ForecastModel(list: [weatherModelStubMobel, weatherModelStubMobel, weatherModelStubMobel, weatherModelStubMobel, weatherModelStubMobel])
let weatherModelStubMobel = WeatherModel(main: dayWeatherModelStubModel, dayTimeStamp: 1584824400)
let dayWeatherModelStubModel = DayWeatherModel(temp: 27, feelsLike: 25)

// CityDetailsModel
let cityDetailsModelStubData = CityDetailsModel(name: "Prishtina", forecast: ForecastModelStubModel)
