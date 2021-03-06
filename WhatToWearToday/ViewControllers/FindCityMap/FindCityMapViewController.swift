//
//  FindCityMapViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit
import MapKit
import SwiftLocation

class FindCityMapViewController: UIViewController, UIGestureRecognizerDelegate, HasDependencies {

    // MARK: - Dependencies

    private lazy var locationService: LocationService = dependencies.locationService()
    private lazy var weatherService: WeatherService = dependencies.weatherService()

    // MARK: - Outlets

    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var choosenCityButton: UIButton!
    @IBOutlet weak var cityDescriptionButton: UIButton!

    // MARK: - Properties

    var cityForecast: ForecastModel?

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Add UITapGestureRecognizer on MKMapView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapKitTaps))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        // Drop pin to user current location
        getCurrentLocation()
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Methods

    /// Observe user clicks over the MKMapView
    @objc func handleMapKitTaps(gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let locationInMap = mapView.convert(location, toCoordinateFrom: mapView)
        reverseGeocode(location: CLLocation(latitude: locationInMap.latitude, longitude: locationInMap.longitude))
    }

    /// Get weather data from API
    private func getWeatherData(fromLocation location: CLLocation) {
        let locationCoordinates2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        weatherService.cityWeather(cityCoordinates: locationCoordinates2D) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint("Error: ", error)
            case .success(let cityForecast):
                self.cityForecast = cityForecast
                if let city = cityForecast.list.first, let weather = city.main {
                    let temperature = String(weather.tempToCelsius) + "°"
                    let cityTemp = cityForecast.city.name + " - " + temperature
                    self.choosenCityButton.setTitle(cityTemp, for: .normal)
                }
            }
        }
    }

    /// Get user location with GPS
    func getCurrentLocation() {
        locationService.getCurrentLocationFromGPS(subscription: .oneShot, desiredAccuracy: .city, useInaccurateLocationIfTimeout: true)  { [weak self] (result) in
            //locationService.getCurrentApproximateLocation { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                debugPrint("Error :", error, #line)
                self.getApproximateLocation()
            case .success(let location):
                self.reverseGeocode(location: CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
            }
        }
    }

    /// Get user location with IP
    func getApproximateLocation() {
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
                let city = places.first?.locality

                if let cityName = city {
                    self.searchCityTextField.text = cityName
                    self.choosenCityButton.setTitle(cityName, for: .normal)
                    self.cityDescriptionButton.setTitle("See more details", for: .normal)
                    self.centerMapOnLocation(location: location)
                    self.getWeatherData(fromLocation: location)
                    self.addAnnotation(inCoordinates: location.coordinate)
                    self.searchCityTextField.resignFirstResponder()
                } else {
                    self.cityForecast = nil
                    self.choosenCityButton.setTitle("Choose a city", for: .normal)
                    self.cityDescriptionButton.setTitle("Search or tap on map", for: .normal)
                }
            }
        }
    }

    /// Place annotation on MKMapView
    private func addAnnotation(inCoordinates: CLLocationCoordinate2D) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = inCoordinates
        mapView.addAnnotation(annotation)
    }

    /// Focus on center of the MKMapView
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                       latitudinalMeters: 15000, longitudinalMeters: 15000)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    /// Get CLLocation from text of searchCityTextField
    private func getLocationPlacemark(address: String) {
        locationService.fetchCoordinates(forAddress: address) { (result) in
            switch result {
            case .success(let placemark):
                self.reverseGeocode(location: CLLocation(latitude: placemark.coordinates.latitude, longitude: placemark.coordinates.longitude))
            case .failure(let error):
                debugPrint("Error :", error, #line)
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func locateMeButtonPressed(_ sender: Any) {
        getCurrentLocation()
    }

    @IBAction func locationTextFieldPrimaryActionTriggered(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.text, text != "" {
            getLocationPlacemark(address: text)
        }
    }

    @IBAction func cityDetailsPressed(_ sender: Any) {
        if cityForecast != nil {
            self.performSegue(withIdentifier: .cityDetails, sender: cityForecast)
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension FindCityMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "LocationPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.image = #imageLiteral(resourceName: "pin_red_icon")
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }
}

// MARK: - Navigation

extension FindCityMapViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        case cityDetails
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue) {
        case .cityDetails:
            if let reminderDetailsViewController = segue.destination as? WWCityDetailsTableViewController, let forecastData = sender as? ForecastModel {
                reminderDetailsViewController.forecast = forecastData
            }
        }
    }
}
