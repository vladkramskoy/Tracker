//
//  TrackerStore.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 09.07.2024.
//

import UIKit
import CoreData

final class TrackerStore {
    var context: NSManagedObjectContext
    
    convenience init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            self.init(context: context)
        } else {
            fatalError("Unable to retriwe retrieve AppDelegate")
        }
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewTrackerToCategory(_ tracker: Tracker, categoryName: String) {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        do {
            if let category = try context.fetch(fetchRequest).first {
                let newTracker = TrackerCoreData(context: context)
                newTracker.name = tracker.name
                newTracker.emoji = tracker.emoji
                newTracker.id = tracker.id.uuidString
                
                if let colorData = try? NSKeyedArchiver.archivedData(withRootObject: tracker.color, requiringSecureCoding: false) {
                    newTracker.color = colorData
                }
                
                let encoder = JSONEncoder()
                if let scheduleData = try? encoder.encode(tracker.schedule) {
                    newTracker.schedule = scheduleData
                }
                
                category.addToTrackers(newTracker)
                try context.save()
            } else {
                print("Category not found")
            }
        } catch {
            print("Failed to fatch or save context: \(error)")
        }
    }
}

