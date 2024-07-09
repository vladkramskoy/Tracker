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
}
