//
//  HomeViewController.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/20/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Manage navigation bar visibility
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Manage navigation bar visibility
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Unwind to Home
    @IBAction func prepareForUnwindToHome(_ segue: UIStoryboardSegue) {}
}
