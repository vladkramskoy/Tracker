//
//  UIApplication+Extensions.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 08.07.2024.
//

import UIKit
import CoreData

extension UIApplication {
    var managedObjectContext: NSManagedObjectContext? {
        let delegate = self.delegate as? AppDelegate
        return delegate?.persistentContainer.viewContext
    }
}
