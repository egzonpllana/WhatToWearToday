//
//  PlaceMark.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

struct PlaceMark {
    let country: String?
    let address: String?
    let suburb: String?
    let state: String?
    let postcode: String?
    let coordinates: (latitude: Double, longitude: Double)
}
