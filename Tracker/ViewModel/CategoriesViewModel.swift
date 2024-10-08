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
    static var selectedIndexPath: IndexPath? { get set }
    var onCategoriesUpdated: ((Bool, Bool) -> Void)? { get set }
    var filteredCategories: [TrackerCategory] { get }

    func updateUI()
    func cellDidTapped()
    func handleViewDidLoad()
    func triggerFeedback()
    func didSelectRowAt(_ index: Int)
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    static var selectedCategory: TrackerCategory? = nil
    static var selectedCategoryString: String? = nil
    static var selectedIndexPath: IndexPath?
    private let trackerCategoryStore = TrackerCategoryStore()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var onCategoriesUpdated: ((Bool, Bool) -> Void)?
    
    var filteredCategories: [TrackerCategory] {
        return categories.filter { $0.name != "Закрепленные" }
    }
    
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            self.categories = filteredCategories
        }
    }
    
    func updateUI() {
        categories = trackerCategoryStore.fetchCategories() ?? []
        let isEmpty = filteredCategories.isEmpty
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
    
    func didSelectRowAt(_ index: Int) {
        CategoriesViewModel.selectedIndexPath = IndexPath(row: index, section: 0)
        CategoriesViewModel.selectedCategoryString = filteredCategories[index].name
        CategoriesViewModel.selectedCategory = filteredCategories[index]
    }
}
