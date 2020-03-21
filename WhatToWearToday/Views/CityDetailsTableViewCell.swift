//
//  CityDetailsTableViewCell.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit

class CityDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func populateCell(withCityWeather weather: WeatherModel) {
        guard let forecast = weather.main, let timeStamp = weather.dayTimeStamp else {
            return
        }

        let timestampToDate = Date(timeIntervalSince1970: Double(timeStamp)).readableDate
        self.dayLabel.text = timestampToDate

        // Beautify dummy data from server, ex 284.21 -> 28°
        let temperature = String(Int(round(forecast.temp/10))) + "°"
        let feelsLike = "Feels like " + String(Int(round(forecast.feelsLike/10))) + "°"

        self.temperatureLabel.text = temperature
        self.feelsLikeLabel.text = feelsLike
    }

}
