//
//  WWLocationService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftLocation
import Contacts

class WWLocationService: LocationService {

    var authorizationStatus: CLAuthorizationStatus { return CLLocationManager.authorizationStatus() }

    private let geocoder: CLGeocoder
    private let googleOptionsWithApiKey: GeocoderRequest.GoogleOptions

    init(googleAPIKey: String? = nil) {
        googleOptionsWithApiKey = GeocoderRequest.GoogleOptions(APIKey: googleAPIKey)
        geocoder = CLGeocoder()
    }

    func getCurrentApproximateLocation(completion: @escaping (Result<CLLocation>) -> Void) {
        LocationManager.shared.requireUserAuthorization()
        LocationManager.shared.locateFromIP(service: .ipAPI) { result in
          switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
          case .success(let location):
            guard let latitude = location.coordinates?.latitude, let longitude = location.coordinates?.longitude else {
                DispatchQueue.main.async {
                completion(Result.failure(LocationServiceError.locationError))
                }
                return
            }
            let cllocation = CLLocation(latitude: latitude, longitude: longitude)
            DispatchQueue.main.async {
                completion(Result.success(cllocation))
            }
          }
        }
    }

    func getCurrentLocation(desiredAccuracy: LocationManager.Accuracy, useInaccurateLocationIfTimeout: Bool, completion: @escaping (Result<CLLocation>) -> Void) {
        // Wait 10s max after authorization has been determined
        LocationManager.shared.locateFromGPS(.continous, accuracy: .city) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            case .success(let location):
                DispatchQueue.main.async {
                    completion(Result.success(location))
                }
            }
        }
    }

    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[CLPlacemark]>) -> Void) {
        LocationManager.shared.locateFromCoordinates(coordinate, timeout: nil, service: .google(googleOptionsWithApiKey)) { (result) in
            switch result {
              case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
              case .success(let places):
                DispatchQueue.main.async {
                    completion(Result.success(places.map({ $0.placemark }).compactMap({ $0 })))
                }
            }
        }
    }

    func reverseGeocodeAddress(address: String, suburb: String, state: String, postcode: String, completion: @escaping (Result<PlaceMark>) -> Void) {
        let fullAddress = "\(address), \(suburb), \(state), \(postcode)"
        fetchCoordinates(forAddress: fullAddress, completion: completion)
    }

    func fetchCoordinates(forAddress address: String, completion: @escaping (Result<PlaceMark>) -> Void) {
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                guard let clError = error as? CLError else { fatalError("Error should be of type CLError") }
                completion(Result.failure(LocationServiceError.errorResponse(for: clError)))
            } else if let placemark = placemarks?.first {
                guard let location = placemark.location,
                    let postalAddress = placemark.postalAddress else {
                        DispatchQueue.main.async {
                            completion(Result.failure(LocationServiceError.locationUnknown))
                        }
                        return
                }
                let placeMarkObject = PlaceMark(country: postalAddress.country,
                                                address: postalAddress.street,
                                                suburb: postalAddress.city,
                                                state: postalAddress.state,
                                                postcode: postalAddress.postalCode,
                                                coordinates: (latitude: location.coordinate.latitude,
                                                              longitude: location.coordinate.longitude))
                DispatchQueue.main.async {
                    completion(Result.success((placeMarkObject)))
                }
            } else {
                DispatchQueue.main.async {
                    completion(Result.failure(LocationServiceError.locationUnknown))
                }
            }
        }
    }

    func autocomplete(_ text: String, completion: @escaping (Result<CLPlacemark>) -> Void) {
        // placeDetail maybe a placeID (for Google) or a full address string already completed using partialMatch search.
        LocationManager.shared.autocomplete(partialMatch: .placeDetail("Piazza della Repubblica, Roma"), service: .apple(nil)) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            case .success(let places):
                if let firstLocation = places.first, let placeMark = firstLocation.fullMatch?.placemark {
                    DispatchQueue.main.async {
                        completion(Result.success(placeMark))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(Result.failure(LocationServiceError.locationPlacemarkError))
                    }
                }
            }
        }
    }
}
