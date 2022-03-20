//
//  Util.swift
//  TheDangersOfSitting
//
//  Created by IcedOtaku on 2022/3/20.
//

import Foundation

class DateUtil {
    static let shared: DateUtil = DateUtil()

    func getTodayDate(hour: Int, minute: Int = 0, second: Int = 0) -> Date {
        let date: Date = Date()
        let calendar: Calendar = Calendar.current
        
        let dateComponents = DateComponents(
            calendar: Calendar.current,
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date),
            day: calendar.component(.day, from: date),
            hour: hour,
            minute: minute,
            second: second
        )
        
        return dateComponents.date ?? date
    }

}
