//
//  FindCityMapViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit
import MapKit

class FindCityMapViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    
    @IBAction func locateMeButtonPressed(_ sender: Any) {
    }
}
