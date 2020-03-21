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

// MARK: - LocationService

protocol LocationService {
    /*
     **Get location Authorization status**
     * Details:
     - Get authorization status of type CLAuthorizationStatu
     - Parameters:
     - no parameters
     - Completion: Boolean value
     */
    var authorizationStatus: CLAuthorizationStatus { get }

    /*
     **Get user Location based on localeIP**
     * Details:
     - Get user location based on the IP
     - Parameters:
     - no parameters
     - Completion: CLLocation or LocationManager.ErrorReason
     */
    func getCurrentApproximateLocation(completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void)

    /*
     **Get user Location from GPS**
     * Details:
     - Get user location from GPS
     - Parameters:
     - desiredAccuracy: CLLocationAccuracy
     - useInaccurateLocationIfTimeout: Bool
     - Completion: CLLocation or LocationManager.ErrorReason
     */
    func getCurrentLocationFromGPS(desiredAccuracy: CLLocationAccuracy, useInaccurateLocationIfTimeout: Bool, completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void)

    /*
     **Get CLPlacemark from CLLocationCoordinate2D**
     * Details:
     - Convert CLLocationCoordinate2D to [CLPlacemark]
     - Parameters:
     - coordinate: CLLocationCoordinate2D
     - Completion: [CLPlacemark] or LocationManager.ErrorReason
     */
    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[CLPlacemark], LocationManager.ErrorReason>) -> Void)

    /*
     **Get suggestions for places based on text given**
     * Details:
     - Provide suggestions for places or address in a particular region
     - Parameters:
     - text: String
     - Completion: CLPlacemark or LocationManager.ErrorReason
     */
    func autocomplete(_ text: String, completion: @escaping (Result<CLPlacemark, LocationManager.ErrorReason>) -> Void)

    /*
     **Get CLPlacemark from constructed model**
     * Details:
     - Convert location informations to PlaceMark model
     - Parameters:
     - address: String
     - suburb: String
     - state: String
     - postcode: String
     - Completion: PlaceMark or LocationServiceError
     */
    func reverseGeocodeAddress(address: String, suburb: String, state: String, postcode: String, completion: @escaping (Result<PlaceMark, LocationServiceError>) -> Void)

    /*
     **Get CLPlacemark from location given in String type**
     * Details:
     - Convert location given in String type to PlaceMark model
     - Parameters:
     - address: String
     - Completion: PlaceMark or LocationServiceError
     */
    func fetchCoordinates(forAddress address: String, completion: @escaping (Result<PlaceMark, LocationServiceError>) -> Void)
}

extension LocationService {
    func getCurrentLocationFromGPS(desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyThreeKilometers, useInaccurateLocationIfTimeout: Bool = true, completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void) {
        self.getCurrentLocationFromGPS(desiredAccuracy: desiredAccuracy, useInaccurateLocationIfTimeout: useInaccurateLocationIfTimeout, completion: completion)
    }
}

// MARK: - LocationServiceError

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

extension LocationServiceError: LocalizedError {
    public var errorDescription: String? {
        return rawValue
    }
}
