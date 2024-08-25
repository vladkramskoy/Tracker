//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Vladislav Kramskoy on 10.08.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testOnboardingPageViewController() {
        let vc = OnboardingPageViewController()
        assertSnapshot(of: vc, as: .image, named: "OnboardingPageViewController")
    }
    
    func testTrackersViewController() {
        let vc = TrackersViewController()
        vc.loadViewIfNeeded()
        assertSnapshot(of: vc, as: .image, named: "TrackersViewController")
    }
    
    func testTrackersCollectionViewCell() {
        let cell = TrackersCollectionViewCell()
        cell.iconLabel.text = "🥶"
        cell.cardView.backgroundColor = .blue
        cell.textLabel.text = "Тест ячейки"
        cell.completeButton.backgroundColor = cell.cardView.backgroundColor
        cell.periodLabel.text = "0 дней"
        cell.frame = CGRect(x: 0, y: 0, width: 148, height: 148)
        cell.layoutIfNeeded()
        
        assertSnapshot(of: cell, as: .image, named: "TrackersCollectionViewCell")
    }
    
    func testCreateTrackerViewController() {
        let vc = CreateTrackerViewController()
        assertSnapshot(of: vc, as: .image, named: "CreateTrackerViewController")
    }
    
    func testNewHabitViewController() {
        let vc = NewHabitViewController()
        assertSnapshot(of: vc, as: .image, named: "NewHabitViewController")
    }
    
    func testNewIrregularEventViewController() {
        let vc = NewIrregularEventViewController()
        assertSnapshot(of: vc, as: .image, named: "NewIrregularEventViewController")
    }
    
    func testCategoriesViewController() {
        let viewModel = CategoriesViewModel()
        let vc = CategoriesViewController(viewModel: viewModel)
        assertSnapshot(of: vc, as: .image, named: "CategoriesViewController")
    }
    
    func testNewCategoryViewController() {
        let vc = NewCategoryViewController()
        assertSnapshot(of: vc, as: .image, named: "NewCategoryViewController")
    }
    
    func testScheduleViewController() {
        let vc = ScheduleViewController()
        assertSnapshot(of: vc, as: .image, named: "ScheduleViewController")
    }
}
