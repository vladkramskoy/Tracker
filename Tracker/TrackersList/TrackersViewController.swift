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
    private var dateFilteredTrackerCategories: [TrackerCategory] = []
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let trackerCategoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.placeholder = "Поиск"
        searchField.textColor = UIColor(named: "customGray")
        searchField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
    }()
    
    private lazy var stubView: UIView = {
        let stubView = UIView()
        stubView.translatesAutoresizingMaskIntoConstraints = false
        return stubView
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
    
    private lazy var stubDefault: Stub = {
        return Stub(image: UIImage(named: "stubImage") ?? UIImage(), textLabel: "Что будем отслеживать?")
    }()
    
    private lazy var stubSearch: Stub = {
        return Stub(image: UIImage(named: "stubImageSearch") ?? UIImage(), textLabel: "Ничего не найдено")
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        TrackersViewController.categories = trackerCategoryStore.fetchCategories() ?? []
        completedTrackers = trackerRecordStore.fetchTrackerRecords()
        filterTrackers(for: currentDate)
        setupSubview()
        setupConstraints()
        setupAppearance()
        setupNavigationBar()
        collectionView.delegate = self
        collectionView.dataSource = self
        searchField.delegate = self
        updateUI(with: stubDefault)
        setupNotificationObserver()
        view.addGestureRecognizer(tapGesture)
        feedbackGenerator.prepare()
    }
    
    private func setupSubview() {
        view.addSubview(searchField)
        view.addSubview(stubView)
        stubView.addSubview(stubImage)
        stubView.addSubview(stubLabel)
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            stubView.heightAnchor.constraint(equalToConstant: 106),
            stubView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stubView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            stubView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 44),
            
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.topAnchor.constraint(equalTo: stubView.topAnchor),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            iconView.tintColor = UIColor(named: "customGray")
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
        
        dateFilteredTrackerCategories = TrackersViewController.categories.map { category in
            let filteredTrackers = category.trackers.filter { tracker in
                return tracker.schedule[weekday] == true
            }
            return TrackerCategory(name: category.name, trackers: filteredTrackers)
        }.filter { !$0.trackers.isEmpty }
        updateUI(with: stubDefault)
        filterContentForSearchText(searchField.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        if searchText.isEmpty {
            filteredTrackerCategories = dateFilteredTrackerCategories
            updateUI(with: stubDefault)
        } else {
            filteredTrackerCategories = dateFilteredTrackerCategories.map { category in
                let filteredTrackers = category.trackers.filter { tracker in
                    tracker.name.lowercased().contains(searchText.lowercased())
                }
                return filteredTrackers.isEmpty ? nil : TrackerCategory(name: category.name, trackers: filteredTrackers)
            }.compactMap { $0 }
            updateUI(with: stubSearch)
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTrackers), name: NSNotification.Name("TrackerCreated"), object: nil)
    }
    
    private func countCompletedTrackers(for trackerID: UUID) -> Int {
        return completedTrackers.filter { $0.id == trackerID }.count
    }
    
    private func updateUI(with stub: Stub) {
        DispatchQueue.main.async {
            if self.filteredTrackerCategories.isEmpty {
                self.stubView.isHidden = false
                self.collectionView.isHidden = true
                
                self.stubImage.image = stub.image
                self.stubLabel.text = stub.textLabel
            } else {
                self.stubView.isHidden = true
                self.collectionView.isHidden = false
            }
            self.collectionView.reloadData()
        }
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
    
    private func handleButtonTap(for tracker: Tracker) {
        guard currentDate <= Date() else {
            // TODO: Уведомить пользователя, что отметка возможна только для текущего дня
            print("Отметка трекера возможна только для текущего дня")
            return
        }
        
        if let index = completedTrackers.firstIndex(where: { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) }) {
            let recordToDelete = completedTrackers[index]
            completedTrackers.remove(at: index)
            try? trackerRecordStore.deleteTrackerRecord(by: recordToDelete.id, on: recordToDelete.date)
        } else {
            let record = TrackerRecord(date: currentDate, id: tracker.id)
            completedTrackers.append(record)
            try? trackerRecordStore.addTrackerRecord(record)
        }
        collectionView.reloadData()
    }
    
    @objc private func addTrackerButtonTapped() {
        feedbackGenerator.impactOccurred()
        let creatingTrackerViewController = CreateTrackerViewController()
        creatingTrackerViewController.title = "Создание трекера"
        let navigationController = UINavigationController(rootViewController: creatingTrackerViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func datePickerValueChanget(_ sender: UIDatePicker) {
        currentDate = sender.date
    }
    
    @objc private func updateTrackers() {
        TrackersViewController.categories = trackerCategoryStore.fetchCategories() ?? []
        filterTrackers(for: currentDate)
        collectionView.reloadData()
    }
    
    @objc func searchTextChanged(_ textField: UISearchTextField) {
        guard let searchText = textField.text else { return }
        filterContentForSearchText(searchText)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
        cell.completeButton.backgroundColor = cell.cardView.backgroundColor
        
        let tracker = filteredTrackerCategories[indexPath.section].trackers[indexPath.item]
        let completedCount = countCompletedTrackers(for: tracker.id)
        if completedCount == 0 {
            cell.periodLabel.text = "\(completedCount) дней"
        } else {
            cell.periodLabel.text = "\(completedCount) день"
        }
        
        let isCompleted = completedTrackers.contains(where: { $0.id == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: currentDate) })
        cell.trackerCompleted(isCompleted)
        cell.buttonAction = { [weak self] in
            self?.handleButtonTap(for: tracker)
        }
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

extension TrackersViewController: UISearchTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchField {
            searchField.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = 38
        let currentString: NSString = searchField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLenght
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchField.text = ""
        filterContentForSearchText(searchField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.resignFirstResponder()
        return true
    }
}

/*
 После добавления логики UIDatePicker, коллекция формируется из отфильтрованных данных (filteredTrackerCategories). Чтобы сформировать коллекцию из общих данных нужно подменить 6 ссылок на категории в методах протокола DataSource и 1 ссылку в методе updateUI.
 */
