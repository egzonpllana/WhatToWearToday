//
//  WWCityDetailsTableViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit
import MapKit

class WWCityDetailsTableViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet weak var cityNameLabel: UILabel!

    // MARK: - Properties

    var forecast: ForecastModel!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Load city name
        cityNameLabel.text = forecast.city.name

        // Do any additional setup after loading the view.
    }
}

// MARK: - Table view data source

extension WWCityDetailsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cityDetailsCell: CityDetailsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cityDetailsCell.populateCell(withCityWeather: forecast.list[indexPath.row])
        return cityDetailsCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecast.list.count
    }
}
