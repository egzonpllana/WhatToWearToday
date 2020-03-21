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

    // MARK: - Properties

    var city: CityDetailsModel!

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let weatherData = city.forecast.list[indexPath.row]
        cityDetailsCell.populateCell(withCityWeather: weatherData)
        return cityDetailsCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return city.forecast.list.count
    }
}
