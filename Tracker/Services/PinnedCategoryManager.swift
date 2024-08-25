//
//  PinnedCategoryManager.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 20.08.2024.
//

import Foundation

final class PinnedCategoryManager {
    private let userDefaultsKey = "trackerOriginalCategories"
    
    func saveOriginalCategory(for trackerID: UUID, categoryName: String) {
        var originalCategories = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] ?? [:]
        originalCategories[trackerID.uuidString] = categoryName
        UserDefaults.standard.set(originalCategories, forKey: userDefaultsKey)
    }
    
    func loadOriginalCategories() -> [UUID: String] {
        let originalCategories = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] ?? [:]
        var result: [UUID: String] = [:]
        for (key, value) in originalCategories {
            if let uuid = UUID(uuidString: key) {
                result[uuid] = value
            }
        }
        return result
    }
    
    func removeOriginalCategory(for trackerID: UUID) {
        var originalCategories = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: String] ?? [:]
        originalCategories.removeValue(forKey: trackerID.uuidString)
        UserDefaults.standard.set(originalCategories, forKey: userDefaultsKey)
    }
}
