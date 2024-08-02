//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 31.07.2024.
//

import UIKit

protocol CategoriesViewModelProtocol: AnyObject {
    static var selectedCategory: TrackerCategory? { get set }
    static var selectedCategoryString: String? { get set }
    var selectedIndexPath: IndexPath? { get set }
    var onCategoriesUpdated: ((Bool, Bool) -> Void)? { get set }

    func updateUI()
    func cellDidTapped()
    func handleViewDidLoad()
    func triggerFeedback()
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    static var selectedCategory: TrackerCategory? = nil
    static var selectedCategoryString: String? = nil
    private let trackerCategoryStore = TrackerCategoryStore()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
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
    
    func handleViewDidLoad() {
        feedbackGenerator.prepare()
    }
    
    func triggerFeedback() {
         feedbackGenerator.impactOccurred()
     }
}