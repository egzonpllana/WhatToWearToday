//
//  LocationService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import CoreLocation

struct PlaceMark {
    let country: String?
    let address: String?
    let suburb: String?
    let state: String?
    let postcode: String?
    let coordinates: (latitude: Double, longitude: Double)
}

enum LocationServiceError: String, CaseIterable {

    case locationError = "Location Error"
    case noResult = "No result"
    case locationUnknown = "Unable to obtain a location for the provided address"
    case locationPlacemarkError = "Location Placemark Error"

    static func errorResponse(for clError: CLError) -> LocationServiceError {
        return self.allCases[clError.code.rawValue]
    }

}

protocol LocationService {
    var authorizationStatus: CLAuthorizationStatus { get }
    func getCurrentApproximateLocation(completion: @escaping (Result<CLLocation>) -> Void)
    func getCurrentLocation(desiredAccuracy: CLLocationAccuracy, useInaccurateLocationIfTimeout: Bool, completion: @escaping (Result<CLLocation>) -> Void)
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[CLPlacemark]>) -> Void)
    func autocomplete(_ text: String, completion: @escaping (Result<CLPlacemark>) -> Void)
    func reverseGeocodeAddress(address: String, suburb: String, state: String, postcode: String, completion: @escaping (Result<PlaceMark>) -> Void)
    func fetchCoordinates(forAddress address: String, completion: @escaping (Result<PlaceMark>) -> Void)
}

extension LocationService {
    func getCurrentLocation(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers, useInaccurateLocationIfTimeout: Bool = true, completion: @escaping (Result<CLLocation>) -> Void) {
        self.getCurrentLocation(desiredAccuracy: desiredAccuracy, useInaccurateLocationIfTimeout: useInaccurateLocationIfTimeout, completion: completion)
    }
}

extension LocationServiceError: LocalizedError {
    public var errorDescription: String? {
        return rawValue
    }
}
