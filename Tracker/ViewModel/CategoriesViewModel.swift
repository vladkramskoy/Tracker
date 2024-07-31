//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 31.07.2024.
//

import UIKit

final class CategoriesViewModel {
    static var selectedCategory: TrackerCategory? = nil
    static var selectedCategoryString: String? = nil
    private let trackerCategoryStore = TrackerCategoryStore()
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var selectedIndexPath: IndexPath?
    var onCategoriesUpdated: ((Bool, Bool) -> Void)?

    func updateUI() {
        TrackersViewController.categories = trackerCategoryStore.fetchCategories() ?? []
        let isEmpty = TrackersViewController.categories.isEmpty
        onCategoriesUpdated?(isEmpty, !isEmpty)
    }
    
    func cellDidTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("CategoryDidSelected"), object: nil)
    }
    
    func triggerFeedback() {
         feedbackGenerator.impactOccurred()
     }
}
