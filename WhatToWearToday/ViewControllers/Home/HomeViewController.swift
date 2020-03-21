//
//  HomeViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

// NOTE: Home screen design is inspired by:
// https://dribbble.com/shots/6609092-Weather-iOS-app-interaction
// https://dribbble.com/shots/6887377-Weather-Cards

import UIKit
import MapKit

class HomeViewController: UIViewController , HasDependencies {

    // MARK: - Dependencies

    private lazy var locationService: LocationService = dependencies.locationService()
    private lazy var weatherService: WeatherService = dependencies.weatherService()

    // MARK: - Outlets

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tempFeelsLikeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Load current day
        loadCurrentDay()

        /// Get user location
        getCurrentLocation()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        /// Manage navigation bar visibility
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /// Manage navigation bar visibility
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Unwind to Home
    
    @IBAction func prepareForUnwindToHome(_ segue: UIStoryboardSegue) {}

    // MARK: - Methods

    private func loadCurrentDay() {
        let date = Date()
        let dateFormatter = DateFormatter()

        /// Get date
        dateFormatter.dateFormat = "dd"
        dateLabel.text = dateFormatter.string(from: date)

        /// Get day
        dateFormatter.dateFormat = "LLL"
        dayLabel.text = dateFormatter.string(from: date)
    }

    private func getWeatherData(fromCoordinates coordinates: CLLocationCoordinate2D) {
        weatherService.cityWeather(cityCoordinates: coordinates) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint("Error: ", error)
            case .success(let cityForecast):
                guard let forecast = cityForecast.list.first, let cityTemperature = forecast.main else {
                    debugPrint("There was an error getting city forecast!", #line)
                    return
                }

                // Beautify dummy data from server, ex 284.21 -> 28°
                let temperature = String(Int(round(cityTemperature.temp/10))) + "°"
                let feelsLike = "Feels like " + String(Int(round(cityTemperature.feelsLike/10))) + "°"

                self.temperatureLabel.text = temperature
                self.tempFeelsLikeLabel.text = feelsLike
            }
        }
    }

    /// Get user location with LocationService
    private func getCurrentLocation() {
        locationService.getCurrentLocationFromGPS(subscription: .oneShot, desiredAccuracy: .city, useInaccurateLocationIfTimeout: true)  { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint("Error: ", error)
            case .success(let location):
                let locationCoordinates = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.reverseGeocode(location: locationCoordinates)

                let locationCoordinates2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                self.getWeatherData(fromCoordinates: locationCoordinates2D)
            }
        }
    }

    private func getApproximateLocation() {
        locationService.getCurrentApproximateLocation { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint("Error :", error, #line)
            case .success(let location):
                self.reverseGeocode(location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
        }
    }

    /// Get reversed geocode from CLLocation
    private func reverseGeocode(location: CLLocation) {
        self.locationService.reverseGeocode(coordinate: location.coordinate) { (result) in
            switch result {
            case .failure(let error):
                debugPrint("Error :", error, #line)
            case .success(let places):
                if let city = places.first?.locality {
                    self.cityLabel.text = city
                }
            }
        }
    }

}

// MARK: - Navigation

extension HomeViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case findCityMap
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .findCityMap:
            break
        }
    }

}
