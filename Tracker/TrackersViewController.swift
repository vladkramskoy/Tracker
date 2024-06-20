//
//  ViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.text = "Поиск"
        searchField.textColor = UIColor(named: "Gray")
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()
    
    private lazy var stubImage: UIImageView = {
        let stubImage = UIImageView()
        stubImage.image = UIImage(named: "stubImage")
        stubImage.translatesAutoresizingMaskIntoConstraints = false
        return stubImage
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.text = "Что будем отслеживать?"
        stubLabel.font = UIFont.systemFont(ofSize: 12)
        stubLabel.textAlignment = .center
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        return stubLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TEST TEST")
        setupSubview()
        setupConstraints()
        setupAppearance()
        setupNavigationBar()
    }
    
    private func setupSubview() {
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -105),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 44),
            
            stubLabel.heightAnchor.constraint(equalToConstant: 18),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        
        if let iconView = searchField.leftView as? UIImageView {
            let tintedImage = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.image = tintedImage
            iconView.tintColor = UIColor(named: "Gray")
        }
    }
    
    private func setupNavigationBar() {
        let addTrackerButton = UIBarButtonItem(image: UIImage(named: "plusIcon"), style: .plain, target: self, action: #selector(addTrackerButtonTapped))
        navigationItem.leftBarButtonItem = addTrackerButton
        
        let datePickerButton = UIBarButtonItem(title: "14.12.22", style: .plain, target: self, action: #selector(datePickerButtonTapped))
        let textAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        datePickerButton.setTitleTextAttributes(textAttributes, for: .normal)
        navigationItem.rightBarButtonItem = datePickerButton
    }
    
    @objc private func addTrackerButtonTapped() {
        print("Кнопка addTrackerButton была нажата")
    }
    
    @objc private func datePickerButtonTapped() {
        print("Кнопка datePickerButton была нажата")
    }
    
    private func completeTracker() {
        // TODO: process code
        let scheduleMock = Schedule(monday: true, tuesday: false, wednesday: false, thursday: false, friday: false, saturday: false, sunday: false)
        let trackerMock = Tracker(id: UUID(), name: "test", color: .black, emoji: "🍏", schedule: scheduleMock)
        let trackerRecordMock = TrackerRecord(date: Date(), id: [trackerMock.id])
        
        completedTrackers.append(trackerRecordMock)
    }
    
    private func cancelCompletedTracker() {
        // TODO: process code
        let scheduleMock = Schedule(monday: true, tuesday: false, wednesday: false, thursday: false, friday: false, saturday: false, sunday: false)
        let trackerMock = Tracker(id: UUID(), name: "test2", color: .black, emoji: "🍊", schedule: scheduleMock)
        let trackerRecordMock = TrackerRecord(date: Date(), id: [trackerMock.id])
        let trackerId = trackerRecordMock.id
        
        completedTrackers.append(trackerRecordMock)
        completedTrackers.removeAll { $0.id == trackerId }
    }
    
    private func addNewCategory() {
        // TODO: process code
        let scheduleMock = Schedule(monday: true, tuesday: false, wednesday: false, thursday: false, friday: false, saturday: false, sunday: false)
        let trackerMock = Tracker(id: UUID(), name: "test", color: .black, emoji: "🍇", schedule: scheduleMock)
        let categoryMock = TrackerCategory(name: "Тестовая категория", trackers: [trackerMock])
        let categoriesListMock = [categoryMock]
        
        categories = categoriesListMock
    }
}

