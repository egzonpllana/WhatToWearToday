//
//  WWCityDetailsTableViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit

class WWCityDetailsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

// MARK: - Table view data source
extension WWCityDetailsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
}
