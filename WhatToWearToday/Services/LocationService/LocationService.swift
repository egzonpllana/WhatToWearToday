//
//  LocationService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftLocation

enum LocationServiceError: String, CaseIterable {
    case locationUnknown = "Unable to obtain a location for the provided address"
}

extension LocationServiceError {
    static func errorResponse(for clError: CLError) -> LocationServiceError {
        // All CLError not handled
        // Check CLError.Code to find all error cases
        return locationUnknown
    }
}

protocol LocationService {
    var authorizationStatus: CLAuthorizationStatus { get }
    func getCurrentApproximateLocation(completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void)
    func getCurrentLocationFromGPS(desiredAccuracy: CLLocationAccuracy, useInaccurateLocationIfTimeout: Bool, completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void)
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[CLPlacemark], LocationManager.ErrorReason>) -> Void)
    func autocomplete(_ text: String, completion: @escaping (Result<CLPlacemark, LocationManager.ErrorReason>) -> Void)
    func reverseGeocodeAddress(address: String, suburb: String, state: String, postcode: String, completion: @escaping (Result<PlaceMark, LocationServiceError>) -> Void)
    func fetchCoordinates(forAddress address: String, completion: @escaping (Result<PlaceMark, LocationServiceError>) -> Void)
}

extension LocationService {
    func getCurrentLocationFromGPS(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers, useInaccurateLocationIfTimeout: Bool = true, completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void) {
        self.getCurrentLocationFromGPS(desiredAccuracy: desiredAccuracy, useInaccurateLocationIfTimeout: useInaccurateLocationIfTimeout, completion: completion)
    }
}

extension LocationServiceError: LocalizedError {
    public var errorDescription: String? {
        return rawValue
    }
}

