//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 14.06.2024.
//

import Foundation

struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
    
    func addingTracker(_ tracker: Tracker) -> TrackerCategory {
        return TrackerCategory(name: name, trackers: trackers + [tracker]) // DEL
    }
}
