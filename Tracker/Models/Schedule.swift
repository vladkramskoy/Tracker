//
//  Schedule.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 14.06.2024.
//

import Foundation

enum WeekDay: CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var localizedString: String {
        switch self {
        case .monday:
            return Localizable.shortWeekDayMonday
        case .tuesday:
            return Localizable.shortWeekDayTuesday
        case .wednesday:
            return Localizable.shortWeekDayWednesday
        case .thursday:
            return Localizable.shortWeekDayThursday
        case .friday:
            return Localizable.shortWeekDayFriday
        case .saturday:
            return Localizable.shortWeekDaySaturday
        case .sunday:
            return Localizable.shortWeekDaySunday
        }
    }
}
