//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 09.07.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore {
    var context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    func fetchCategories() -> [TrackerCategory]? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let trackerCategoriesCoreData = try context.fetch(fetchRequest)
            var trackerCategories: [TrackerCategory] = []
            
            for categoryCoreData in trackerCategoriesCoreData {
                let trackers = categoryCoreData.trackers?.allObjects as? [Tracker] ?? []
                let category = TrackerCategory(name: categoryCoreData.name!, trackers: trackers)
                trackerCategories.append(category)
            }
            return trackerCategories
        } catch {
            print("Failed to fetch categories: \(error)")
            return nil
        }
    }

    func addNewCategory(_ category: TrackerCategory) throws {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.name = category.name
        newCategory.trackers = []
        try context.save()
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
}
