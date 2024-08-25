//
//  CategoryManager.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 19.08.2024.
//

import Foundation

final class CategoryManager {
    private let trackerCategoryStore = TrackerCategoryStore()
    private let pinnedCategoryKey = "pinnedCategoryAdded"
    
    
    func addPinnedCategoryNeeded() {
        let userDefaults = UserDefaults.standard
        
        if !userDefaults.bool(forKey: pinnedCategoryKey) {
            addPinnedCategory()
            userDefaults.set(true, forKey: pinnedCategoryKey)
        }
    }
    
    private func addPinnedCategory() {
        let pinnedCategory = TrackerCategory(name: "Закрепленные", trackers: [])
        
        do {
            try trackerCategoryStore.addNewCategory(pinnedCategory)
        } catch {
            print("Failed to add category: \(error.localizedDescription)")
        }
    }
}
