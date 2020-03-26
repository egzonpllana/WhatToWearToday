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

        let temperature = String(forecast.tempToCelsius) +  "°"
        let feelsLike = "Feels like " + String(forecast.feelsLikeToCelsius) + "°"

        self.temperatureLabel.text = temperature
        self.feelsLikeLabel.text = feelsLike
    }

}
