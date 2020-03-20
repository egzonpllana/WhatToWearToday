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

    // MARK: - Outlets

    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var choosenCityFooterButton: UIButton!
    @IBOutlet weak var cityDescriptionFooterLabel: UILabel!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Add UITapGestureRecognizer on MKMapView
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapKitTaps))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }

    // MARK: - Methods

    /// Observe user clicks over the MKMapView
    @objc func handleMapKitTaps(gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let locationInMap = mapView.convert(location, toCoordinateFrom: mapView)
        reverseGeocode(location: CLLocation(latitude: locationInMap.latitude, longitude: locationInMap.longitude))
    }

    /// Get user location with LocationService
    func getUserCurrentLocation() {
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
                let state = places.first?.subAdministrativeArea
                let city = places.first?.locality
                let street = places.first?.thoroughfare

                self.addAnnotation(inCoordinates: location.coordinate)
                self.centerMapOnLocation(location: location)
                if let streetName = street, let cityName = city, let stateName = state {
                    self.searchCityTextField.text = "\(streetName), \(cityName), \(stateName)"
                    self.choosenCityFooterButton.setTitle("\(streetName), \(cityName), \(stateName)", for: .normal)
                    self.cityDescriptionFooterLabel.text = "See more details"
                } else {
                    self.searchCityTextField.text = ""
                    self.choosenCityFooterButton.setTitle("Choose a city", for: .normal)
                    self.cityDescriptionFooterLabel.text = "Search or tap on map"
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
                                                       latitudinalMeters: 1000, longitudinalMeters: 1000)
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
        getUserCurrentLocation()
    }

    @IBAction func locationTextFieldPrimaryActionTriggered(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.text, text != "" {
            getLocationPlacemark(address: text)
            searchCityTextField.resignFirstResponder()
        }
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
