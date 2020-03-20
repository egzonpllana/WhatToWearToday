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

    // MARK: - Properties
    var newPlaceMark: PlaceMark? /* Will be used to save thorugh API Call */

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Tap location in Map
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMapKitTaps))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }

    // MARK: - Methods

    @objc func handleMapKitTaps(gestureReconizer: UILongPressGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let locationInMap = mapView.convert(location, toCoordinateFrom: mapView)
        reverseGeocode(location: CLLocation(latitude: locationInMap.latitude, longitude: locationInMap.longitude))
    }

    private func reverseGeocode(location: CLLocation) {
        self.locationService.reverseGeocode(coordinate: location.coordinate) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
            case .success(let places):
                let state = places.first?.subAdministrativeArea
                let city = places.first?.locality
                let street = places.first?.thoroughfare
                let postalCode = places.first?.postalCode
                let country = places.first?.country

                guard
                    let latitude = places.first?.location?.coordinate.latitude,
                    let longitude = places.first?.location?.coordinate.longitude else {
                        assertionFailure("There was an error getting latitude and longitude!")
                        return
                }

                self.newPlaceMark = PlaceMark(country: country, address: city, suburb: street, state: state, postcode: postalCode, coordinates: (latitude: latitude, longitude: longitude))
                self.addAnnotation(inCoordinates: location.coordinate)
                self.centerMapOnLocation(location: location)
                self.searchCityTextField.text = "\(street ?? ""), \(city ?? "")"
            }
        }
    }

    private func addAnnotation(inCoordinates: CLLocationCoordinate2D) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = inCoordinates
        mapView.addAnnotation(annotation)
    }

    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate,
                                                       latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    private func getLocationPlacemark(address: String) {
        locationService.fetchCoordinates(forAddress: address) { (result) in
            switch result {
            case .success(let placemark):
                self.reverseGeocode(location: CLLocation(latitude: placemark.coordinates.latitude, longitude: placemark.coordinates.longitude))
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    // MARK: - Actions
    
    @IBAction func locateMeButtonPressed(_ sender: Any) {
        let sydney = CLLocation(latitude: -33.865, longitude: 151.209444)
        reverseGeocode(location: sydney)
    }

    @IBAction func locationTextFieldPrimaryActionTriggered(_ sender: Any) {
        if let textField = sender as? UITextField, let text = textField.text, text != "" {
            getLocationPlacemark(address: text)
            searchCityTextField.resignFirstResponder()
        }
    }
}
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
