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
    var categories: [TrackerCategory] { get }

    func updateUI()
    func cellDidTapped()
    func handleViewDidLoad()
    func triggerFeedback()
    func didSelectRowAt(_ index: Int)
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    static var selectedCategory: TrackerCategory? = nil
    static var selectedCategoryString: String? = nil
    private let trackerCategoryStore = TrackerCategoryStore()
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    var selectedIndexPath: IndexPath?
    var onCategoriesUpdated: ((Bool, Bool) -> Void)?
    
    private(set) var categories: [TrackerCategory] = []
    
    func updateUI() {
        categories = trackerCategoryStore.fetchCategories() ?? []
        let isEmpty = categories.isEmpty
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
        selectedIndexPath = IndexPath(row: index, section: 0)
        CategoriesViewModel.selectedCategoryString = categories[index].name
        CategoriesViewModel.selectedCategory = categories[index]
    }
}
