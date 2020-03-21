//
//  MockLocationService.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation
import CoreLocation
import Intents
import SwiftLocation

class MockLocationService: LocationService {

    lazy var samplePlacemark: CLPlacemark = CLPlacemark(location: CLLocation(latitude: -33.865, longitude: 151.209444),
                                                        name: "Sydney",
                                                        postalAddress: nil)

    var authorizationStatus: CLAuthorizationStatus { return CLLocationManager.authorizationStatus() }

    func getCurrentApproximateLocation(completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void) {
        // Simulate network latency
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5...3.0)) {
            guard let sampleLocation = self.samplePlacemark.location else {
                fatalError("Invalid sample CLPlacemark: \(self.samplePlacemark)")
            }
            completion(Result.success(sampleLocation))
        }
    }

    func getCurrentLocationFromGPS(completion: @escaping (Result<CLLocation, LocationManager.ErrorReason>) -> Void) {
        // Simulate network latency
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5...3.0)) {
            guard let sampleLocation = self.samplePlacemark.location else {
                fatalError("Invalid sample CLPlacemark: \(self.samplePlacemark)")
            }
            completion(Result.success(sampleLocation))
        }
    }

    func reverseGeocode(coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[CLPlacemark], LocationManager.ErrorReason>) -> Void) {
        // Simulate network latency
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5...3.0)) {
            completion(Result.success([self.samplePlacemark]))
        }
    }

    func autocomplete(_ text: String, completion: @escaping (Result<CLPlacemark, LocationManager.ErrorReason>) -> Void) {
        // Simulate network latency
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval.random(in: 0.5...3.0)) {
            completion(Result.failure(LocationManager.ErrorReason.noData(nil)))
        }
    }

    // mock updated the location for the business
    func reverseGeocodeAddress(address: String, suburb: String, state: String, postcode: String, completion: @escaping (Result<PlaceMark, LocationServiceError>) -> Void) {
        // simulate network latency
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let placeMark = PlaceMark(country: "Australia", address: address, suburb: suburb, state: state, postcode: postcode, coordinates: (-32.0558714, 115.7461693))
            completion(Result.success(placeMark))
        }
    }

    func fetchCoordinates(forAddress address: String, completion: @escaping (Result<PlaceMark, LocationServiceError>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let placeMark = PlaceMark(country: "Australia", address: "Perth", suburb: "Montes", state: "Australia", postcode: "6000", coordinates: (-32.0558714, 115.7461693))
            completion(Result.success(placeMark))
        }
    }

}
