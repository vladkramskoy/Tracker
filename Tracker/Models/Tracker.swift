//
//  Tracker.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 14.06.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay: Bool]
}
