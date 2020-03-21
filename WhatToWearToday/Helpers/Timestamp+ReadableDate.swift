//
//  Timestamp+ReadableDate.swift
//  WhatToWearToday
//
//  Created by Egzon Pllana on 3/21/20.
//  Copyright © 2020 Native Coders. All rights reserved.
//

import Foundation

// NOTE: Readable date system is implemented from github gist and improved later from me
// https://gist.github.com/akultomar17/8210340c4808e3d7a2bcb1c0fb4523b8#file-epochtoreadabledates-swift

extension Date {
    var readableDate: String {
        let date = Date(timeIntervalSince1970: self.timeIntervalSince1970)
        let dateFormatter = DateFormatter()
        var time: String

        if Calendar.current.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if Calendar.current.isDateInToday(date) {
            return "Today"
        } else {
            // show year if date is in the next years
            dateFormatter.dateFormat = "dd MMM"
            time = dateFormatter.string(from: date)
            return time
        }
    }

     private func dateFallsInCurrentWeek(date: Date) -> Bool {
        let currentWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: Date())
        let datesWeek = Calendar.current.component(Calendar.Component.weekOfYear, from: date)
        return (currentWeek == datesWeek)
     }
}
