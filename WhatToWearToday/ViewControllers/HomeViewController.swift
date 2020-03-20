//
//  HomeViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController , HasDependencies {

    // MARK: - Dependencies

    private lazy var locationService: LocationService = dependencies.locationService()

    // MARK: - Outlets

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var tempFeelsLikeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load current day
        loadCurrentDay()

        // Get user location
        getUserCurrentLocation()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Manage navigation bar visibility
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Manage navigation bar visibility
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Unwind to Home
    
    @IBAction func prepareForUnwindToHome(_ segue: UIStoryboardSegue) {}

    // MARK: - Methods

    private func loadCurrentDay() {
        let date = Date()
        let dateFormatter = DateFormatter()

        // Get date
        dateFormatter.dateFormat = "dd"
        dateLabel.text = dateFormatter.string(from: date)

        // Get day
        dateFormatter.dateFormat = "LLL"
        dayLabel.text = dateFormatter.string(from: date)
    }

    /// Get user location with LocationService
    private func getUserCurrentLocation() {
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
