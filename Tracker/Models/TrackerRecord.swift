//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 14.06.2024.
//

import Foundation

struct TrackerRecord: Codable, Equatable {
    let date: Date
    let id: UUID
}
