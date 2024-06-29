//
//  ViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit

final class TrackersViewController: UIViewController {
    static var categories: [TrackerCategory] = []
    private var currentDate: Date = Date() {
        didSet {
            filterTrackers(for: currentDate)
        }
    }
    private var completedTrackers: [TrackerRecord] = []
    private var filteredTrackerCategories: [TrackerCategory] = []
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"] // DEL
    
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
        layout.itemSize = CGSize(width: 167, height: 148)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        collectionView.register(TrackersSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersSupplementaryView.identifier)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ***
        
        let schedule: [WeekDay: Bool] = [ // DEL
            .monday: true,
            .tuesday: true,
            .wednesday: true,
            .thursday: true,
            .friday: false,
            .saturday: false,
            .sunday: false
        ]
        
        let schedule2: [WeekDay: Bool] = [ // DEL
            .monday: false,
            .tuesday: false,
            .wednesday: false,
            .thursday: false,
            .friday: true,
            .saturday: true,
            .sunday: true
        ]

        let tracker = Tracker(id: UUID(), name: "Поливать растение", color: UIColor(named: "green")!, emoji: emoji[4], schedule: schedule) // DEL
        let tracker2 = Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: UIColor(named: "orange")!, emoji: emoji[1], schedule: schedule)
        let tracker3 = Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: UIColor(named: "red")!, emoji: emoji[2], schedule: schedule2)
        let tracker4 = Tracker(id: UUID(), name: "Свидания в апреле", color: UIColor(named: "lightBlue")!, emoji: emoji[4], schedule: schedule2)
        let category = TrackerCategory(name: "Домашний уют", trackers: [tracker, tracker4])
        let category2 = TrackerCategory(name: "Радостные мелочи", trackers: [tracker2, tracker3])
        TrackersViewController.categories.append(category)
        TrackersViewController.categories.append(category2)
        
        // ***
        
        filterTrackers(for: currentDate)
        setupSubview()
        setupConstraints()
        setupAppearance()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateUI()
        setupNotificationObserver()
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
            
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
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
    
    private func filterTrackers(for date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        guard let weekDayIndex = components.weekday else { return }
        guard let weekday = convertWeekDay(from: weekDayIndex) else { return }
        
        filteredTrackerCategories = TrackersViewController.categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.schedule[weekday] == true
            }
            return TrackerCategory(name: category.name, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        collectionView.reloadData()
        updateUI()
    }
    
    private func convertWeekDay(from calendarWeekDay: Int) -> WeekDay? {
        switch calendarWeekDay {
        case 1:
            return.sunday
        case 2:
            return.monday
        case 3:
            return.tuesday
        case 4:
            return.wednesday
        case 5:
            return.thursday
        case 6:
            return.friday
        case 7:
            return.saturday
        default:
            return nil
        }
    }
    
    @objc private func addTrackerButtonTapped() {
        let creatingTrackerViewController = CreateTrackerViewController()
        creatingTrackerViewController.title = "Создание трекера"
        let navigationController = UINavigationController(rootViewController: creatingTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func datePickerValueChanget(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
    
    @objc private func updateTrackers() {
        filterTrackers(for: currentDate)
        collectionView.reloadData()
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTrackers), name: NSNotification.Name("TrackerCreated"), object: nil)
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            if self.filteredTrackerCategories.isEmpty {
                self.stubImage.isHidden = false
                self.stubLabel.isHidden = false
            } else {
                self.stubImage.isHidden = true
                self.stubLabel.isHidden = true
                self.collectionView.isHidden = false
            }
            self.collectionView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredTrackerCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTrackerCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as? TrackersCollectionViewCell else { return UICollectionViewCell()
        }
        cell.iconLabel.text = filteredTrackerCategories[indexPath.section].trackers[indexPath.item].emoji
        cell.cardView.backgroundColor = filteredTrackerCategories[indexPath.section].trackers[indexPath.item].color
        cell.textLabel.text = filteredTrackerCategories[indexPath.section].trackers[indexPath.item].name
        cell.periodLabel.text = "1 день"
        cell.completeButton.backgroundColor = cell.cardView.backgroundColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackersSupplementaryView.identifier, for: indexPath) as? TrackersSupplementaryView else { return UICollectionReusableView() }
        view.titleLabel.text = "\(filteredTrackerCategories[indexPath.section].name)"
        view.titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return view
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: process code
        print("Cell tapped at \(indexPath)")
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
        return CGSize(width: (collectionView.bounds.width / 2) - 21, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

/*
 После добавления логики UIDatePicker, коллекция формируется из отфильтрованных данных (filteredTrackerCategories). Чтобы сформировать коллекцию из общих данных нужно подменить 6 ссылок на категории в методах протокола DataSource и 1 ссылку в методе updateUI.
 */
