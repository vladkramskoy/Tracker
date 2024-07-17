//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 09.07.2024.
//

import UIKit
import CoreData

final class TrackerRecordStore {
    var context: NSManagedObjectContext
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchTrackerRecords() -> [TrackerRecord] {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        
        do {
            let recordsCoreData = try context.fetch(fetchRequest)
            let records = recordsCoreData.map { record in
                TrackerRecord(date: record.date ?? Date(), id: record.id ?? UUID())
            }
            return records
        } catch {
            print("Failed to fetch TrackerRecords \(error)")
            return []
        }
    }
    
    func addTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let recordCoreData = TrackerRecordCoreData(context: context)
        recordCoreData.date = trackerRecord.date
        recordCoreData.id = trackerRecord.id
        
        do {
            try context.save()
            print("TrackerRecord saved!")
        } catch {
            print("Failed to save TrackerRecord: \(error)")
        }

    }
    
    func deleteTrackerRecord(by id: UUID, on date: Date) throws {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        fetchRequest.predicate = NSPredicate(format: "id == %@ AND date >= %@ AND date < %@", id as CVarArg, startOfDay as CVarArg, endOfDay as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
            print("TrackerRecord deleted")
        } catch {
            print("Failed to delete TrackerRecord: \(error)")
        }
    }
}
