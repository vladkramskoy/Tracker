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
    private let emojiMock = [ "🍇", "🍈", "🍉", "🍊", "🍋", "🍌", "🍍", "🥭", "🍎", "🍏", "🍐", "🍒", "🍓", "🫐", "🥝", "🍅", "🫒", "🥥", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🍄"] // DEL
    
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
        searchField.textColor = UIColor(named: "gray")
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
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanget(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(TrackersSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersSupplementaryView.identifier)
        collectionView.backgroundColor = .darkGray // DEL
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupConstraints()
        setupAppearance()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        addNewCategory() // DEL
        updateUI()
    }
    
    private func setupSubview() {
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
        view.addSubview(collectionView)
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
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 44),
            
            stubLabel.heightAnchor.constraint(equalToConstant: 18),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        
        if let iconView = searchField.leftView as? UIImageView {
            let tintedImage = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.image = tintedImage
            iconView.tintColor = UIColor(named: "gray")
        }
    }
    
    private func setupNavigationBar() {
        let addTrackerButton = UIBarButtonItem(image: UIImage(named: "plusIcon"), style: .plain, target: self, action: #selector(addTrackerButtonTapped))
        navigationItem.leftBarButtonItem = addTrackerButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    @objc private func addTrackerButtonTapped() {
        let creatingTrackerViewController = CreateTrackerViewController()
        creatingTrackerViewController.title = "Создание трекера"
        let navigationController = UINavigationController(rootViewController: creatingTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func datePickerValueChanget(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
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
    
    private func updateUI() {
        if categories.isEmpty {
            stubImage.isHidden = false
            stubLabel.isHidden = false
        } else {
            stubImage.isHidden = true
            stubLabel.isHidden = true
            collectionView.isHidden = false
        }
        collectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiMock.count // DEL
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell()
        }
        cell.label.text = emojiMock[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackersSupplementaryView.identifier, for: indexPath) as? TrackersSupplementaryView else { return UICollectionReusableView() }
        view.titleLabel.text = "Домашний уют"
        view.titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: process code
        print("didSelectItemAt")
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
