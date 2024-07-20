//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 09.07.2024.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    var context: NSManagedObjectContext
    var insertedIndexes: IndexSet?
    var deletedIndexes: IndexSet?
    
    convenience override init() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            self.init(context: context)
        } else {
            fatalError("Unable to retriwe retrieve AppDelegate")
        }
    }
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = []

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    func fetchCategories() -> [TrackerCategory]? {
        guard let trackerCategoriesCoreData = fetchedResultsController.fetchedObjects else { return nil }
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

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = nil
        deletedIndexes = nil
    }

    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        default:
            break
        }
    }
}
