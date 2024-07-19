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
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            self.init(context: context)
        } else {
            fatalError("Unable to retriwe retrieve AppDelegate")
        }
    }
    
    func fetchCategories() -> [TrackerCategory]? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            let trackerCategoriesCoreData = try context.fetch(fetchRequest)
            var trackerCategories: [TrackerCategory] = []
            
            for categoryCoreData in trackerCategoriesCoreData {
                guard let trackersCoreData = categoryCoreData.trackers?.allObjects as? [TrackerCoreData] else {
                    continue
                }
                
                let trackers = trackersCoreData.compactMap { coreDataTracker -> Tracker? in
                    guard let name = coreDataTracker.name,
                          let emoji = coreDataTracker.emoji,
                          let idString = coreDataTracker.id,
                          let id = UUID(uuidString: idString),
                          let colorData = coreDataTracker.color,
                          let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData),
                          let scheduleData = coreDataTracker.schedule else {
                        return nil
                    }
                    
                    let decoder = JSONDecoder()
                    guard let schedule = try? decoder.decode([WeekDay: Bool].self, from: scheduleData) else {
                        return nil
                    }
                    
                    return Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule)
                }
                
                let category = TrackerCategory(name: categoryCoreData.name ?? String(), trackers: trackers)
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
