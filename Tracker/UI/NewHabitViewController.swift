//
//  NewHabitViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 22.06.2024.
//

import UIKit

final class NewHabitViewController: UIViewController {
    enum Mode {
        case create
        case edit
    }
    
    var mode: Mode = .create {
        didSet {
            configureForCurrentMode()
        }
    }
    var editTracker: Tracker?
    var categoryConteinsTracker: TrackerCategory?
    var oldTrakerName: String?
    
    private let trackerStore = TrackerStore()
    private var cellTitles: [(String, String?)] = [(Localizable.newHabitCategory, nil), (Localizable.newHabitSchedule, nil)] {
        didSet {
            checkAndUpdateCreateButton()
        }
    }
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private var selectEmoji = ""
    private let colors = [UIColor(named: "color1"), UIColor(named: "color2"), UIColor(named: "color3"), UIColor(named: "color4"), UIColor(named: "color5"), UIColor(named: "color6"), UIColor(named: "color7"), UIColor(named: "color8"), UIColor(named: "color9"), UIColor(named: "color10"), UIColor(named: "color11"), UIColor(named: "color12"), UIColor(named: "color13"), UIColor(named: "color14"), UIColor(named: "color15"), UIColor(named: "color16"), UIColor(named: "color17"), UIColor(named: "color18")]
    private var selectColor = UIColor.black
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private var topAnchorConstant: CGFloat?
    private let trackerRecordStore = TrackerRecordStore()
    private var completedTrackers: [TrackerRecord] = []
    private var completedCount: Int?
    
    private lazy var textFieldView: UIView = {
        let textFieldView = UIView()
        textFieldView.backgroundColor = UIColor(named: "superLightGray(darkMode)")
        textFieldView.layer.cornerRadius = 16
        textFieldView.layer.masksToBounds = true
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()
    
    private lazy var trackerNameTextField: UITextField = {
        let trackerNameTextField = UITextField()
        trackerNameTextField.placeholder = Localizable.newHabitName
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17)
        trackerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingChanged)
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameTextField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = UIColor(named: "customGray")
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiCollectionView.backgroundColor = Colors.viewBackgroundColor
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        emojiCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiCollectionView
    }()
    
    private lazy var сolorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let сolorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        сolorsCollectionView.backgroundColor = Colors.viewBackgroundColor
        сolorsCollectionView.register(ColorsCollectionViewCell.self, forCellWithReuseIdentifier: ColorsCollectionViewCell.identifier)
        сolorsCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        сolorsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return сolorsCollectionView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle(Localizable.newHabitCancelButton, for: .normal)
        cancelButton.setTitleColor(UIColor(named: "lightRed"), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(named: "lightRed")?.cgColor
        cancelButton.layer.cornerRadius = 16
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private lazy var createButton: UIButton = {
        let createButton = UIButton(type: .system)
        createButton.setTitle(Localizable.newHabitCreateButton, for: .normal)
        createButton.tintColor = .white
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createButton.layer.cornerRadius = 16
        createButton.backgroundColor = UIColor(named: "customGray")
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.isEnabled = false
        return createButton
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }()
    
    private lazy var trackerDurationLabel = {
        let trackerDurationLabel = UILabel()
        let formatString = NSLocalizedString("numberOfMarkedTrackers", comment: "")
        trackerDurationLabel.text = String.localizedStringWithFormat(formatString, completedCount ?? Int())
        trackerDurationLabel.textAlignment = .center
        trackerDurationLabel.font = UIFont.boldSystemFont(ofSize: 32)
        trackerDurationLabel.translatesAutoresizingMaskIntoConstraints = false
        return trackerDurationLabel
    }()

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("NewHabitViewController has been unloaded from memory.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.viewBackgroundColor
        view.addSubview(scrollView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        scrollView.addSubview(textFieldView)
        scrollView.addSubview(trackerNameTextField)
        scrollView.addSubview(tableView)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(сolorsCollectionView)
        scrollView.addSubview(trackerDurationLabel)
        tableView.delegate = self
        tableView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        сolorsCollectionView.delegate = self
        сolorsCollectionView.dataSource = self
        trackerNameTextField.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupConstraints()
        setupNotificationObserver()
        view.addGestureRecognizer(tapGesture)
        feedbackGenerator.prepare()
        сolorsCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentHeightCreateMode = textFieldView.frame.height + 24 + tableView.frame.height + 32 + emojiCollectionView.frame.height + 16 + сolorsCollectionView.frame.height
        let contentHeightEditMode = trackerDurationLabel.frame.height + 24 + textFieldView.frame.height + 24 + tableView.frame.height + 32 + emojiCollectionView.frame.height + 16 + сolorsCollectionView.frame.height
        let contentHeight = mode == .create ? contentHeightCreateMode : contentHeightEditMode
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: contentHeight)
    }
    
    @objc private func cancelButtonTapped() {
        feedbackGenerator.impactOccurred()
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createButtonTapped() {
        feedbackGenerator.impactOccurred()
        guard let text = trackerNameTextField.text, !text.isEmpty else { return }
        
        if mode == .create {
            if let selectedCategory = CategoriesViewModel.selectedCategory {
                let newTracker = Tracker(id: UUID(), name: text, color: selectColor, emoji: selectEmoji, schedule: ScheduleViewController.schedule)
                trackerStore.addNewTrackerToCategory(newTracker, categoryName: selectedCategory.name)
            }
        } else {
            if let selectedCategory = CategoriesViewModel.selectedCategory, let id = editTracker?.id {
                let editTracker = Tracker(id: id, name: text, color: selectColor, emoji: selectEmoji, schedule: ScheduleViewController.schedule)
                
                do {
                    try trackerStore.deleteTracker(withName: oldTrakerName ?? String())
                } catch {
                    print("Error deleting the tracker: \(error.localizedDescription)")
                }
                trackerStore.addNewTrackerToCategory(editTracker, categoryName: selectedCategory.name)
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("TrackerCreated"), object: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateTableView() {
        DispatchQueue.main.async {
            self.cellTitles = [(Localizable.newHabitCategory, "\(CategoriesViewModel.selectedCategoryString ?? "")"), (Localizable.newHabitSchedule, "\(ScheduleViewController.selectedDays ?? "")")]
            self.tableView.reloadData()
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkAndUpdateCreateButton()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func checkAndUpdateCreateButton() {
        if let text = trackerNameTextField.text, !text.isEmpty, cellTitles[0].1 != "", cellTitles[1].1 != "", selectEmoji != "", selectColor != UIColor.black {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "dark&white(darkMode)")
            createButton.tintColor = UIColor(named: "white&dark(darkMode)")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "customGray")
            createButton.tintColor = .white
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name("ScheduleDidCreated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name("CategoryDidSelected"), object: nil)
    }
    
    private func configureForCurrentMode() {
        switch mode {
        case .create:
            self.topAnchorConstant = 0
            trackerDurationLabel.isHidden = true
        case .edit:
            self.title = Localizable.editHabitTitle
            self.createButton.setTitle(Localizable.editHabitSaveButton, for: .normal)
            self.topAnchorConstant = 78
            self.oldTrakerName = editTracker?.name
            completedTrackers = trackerRecordStore.fetchTrackerRecords()
            trackerDurationLabel.isHidden = false
            
            if let tracker = self.editTracker {
                trackerNameTextField.text = tracker.name
                selectEmoji = tracker.emoji
                selectColor = tracker.color
                
                CategoriesViewModel.selectedCategory = categoryConteinsTracker
                CategoriesViewModel.selectedCategoryString = categoryConteinsTracker?.name
                ScheduleViewController.schedule = tracker.schedule
                ScheduleViewController.selectedDays = ScheduleViewController.schedule.filter { $0.value }.map { $0.key.localizedString }.joined(separator: ", ")
                updateTableView()
                
                self.completedCount = countCompletedTrackersEditMode(for: tracker.id)
                let formatString = NSLocalizedString("numberOfMarkedTrackers", comment: "")
                trackerDurationLabel.text = String.localizedStringWithFormat(formatString, completedCount ?? Int())
            }
        }
    }
    
    private func selectEmojisCellBeforeShowingEditMode() {
        if let tracker = self.editTracker {
            if let index = self.emoji.firstIndex(of: tracker.emoji) {
                let indexPath = IndexPath(item: index, section: 0)
                
                if let cell = emojiCollectionView.cellForItem(at: indexPath) {
                    cell.backgroundColor = UIColor(named: "superLightGray2")
                }
            }
        }
    }
    
    private func selectColorsCellBeforeShowingEditMode() {
        if let tracker = self.editTracker {
            if let index = self.colors.firstIndex(of: tracker.color) {
                let indexPath = IndexPath(item: index, section: 0)
                
                if let cell = сolorsCollectionView.cellForItem(at: indexPath) {
                    cell.layer.borderWidth = 3
                    cell.layer.borderColor = colors[indexPath.row]?.withAlphaComponent(0.3).cgColor
                }
            }
        }
    }
    
    private func deselectCellEmojiEditMode() {
        if let tracker = self.editTracker {
            if let index = self.emoji.firstIndex(of: tracker.emoji) {
                let indexPath = IndexPath(item: index, section: 0)
                
                if let cell = emojiCollectionView.cellForItem(at: indexPath) {
                    cell.backgroundColor = .systemBackground
                }
            }
        }
    }
    
    private func deselectCellColorsEditMode() {
        if let tracker = self.editTracker {
            if let index = self.colors.firstIndex(of: tracker.color) {
                let indexPath = IndexPath(item: index, section: 0)
                
                if let cell = сolorsCollectionView.cellForItem(at: indexPath) {
                    cell.layer.borderWidth = 0
                }
            }
        }
    }
    
    private func countCompletedTrackersEditMode(for trackerID: UUID) -> Int {
        return completedTrackers.filter { $0.id == trackerID }.count
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerDurationLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            trackerDurationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            trackerDurationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            trackerDurationLabel.heightAnchor.constraint(equalToConstant: 38),
            
            textFieldView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topAnchorConstant ?? 0),
            textFieldView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            
            trackerNameTextField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 150),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -16),
            
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            emojiCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            сolorsCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            сolorsCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            сolorsCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            сolorsCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            сolorsCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 161),
        ])
    }
}

extension NewHabitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = cellTitles[indexPath.row].0
        cell.detailTextLabel?.text = cellTitles[indexPath.row].1
        cell.detailTextLabel?.textColor = UIColor(named: "customGray")
        cell.backgroundColor = UIColor(named: "superLightGray(darkMode)")
        cell.accessoryType = .disclosureIndicator
        // TODO: Обработать ситуацию когда отменено создание трекера, а выбранное расписание не сбросилось
        return cell
    }
}

extension NewHabitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewModel = CategoriesViewModel()
            let categoryViewController = CategoriesViewController(viewModel: viewModel)
            categoryViewController.title = Localizable.categoriesTitle
            let navigationController = UINavigationController(rootViewController: categoryViewController)
            present(navigationController, animated: true)
        case 1:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.title = Localizable.scheduleTitle
            let navigationController = UINavigationController(rootViewController: scheduleViewController)
            present(navigationController, animated: true)
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let insetAmount: CGFloat = 16.0
        
        if indexPath.row == cellTitles.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}

extension NewHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emoji.count
        } else if collectionView == сolorsCollectionView {
            return colors.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if mode == .edit {
            selectEmojisCellBeforeShowingEditMode()
            selectColorsCellBeforeShowingEditMode()
        }
        
        if collectionView == emojiCollectionView {
            guard let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.emojiLabel.font = UIFont.systemFont(ofSize: 32)
            cell.emojiLabel.text = emoji[indexPath.row]
            return cell
        } else if collectionView == сolorsCollectionView {
            guard let cell = сolorsCollectionView.dequeueReusableCell(withReuseIdentifier: ColorsCollectionViewCell.identifier, for: indexPath) as? ColorsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.cellView.backgroundColor = colors[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == emojiCollectionView {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {
                return UICollectionReusableView()
            }
            view.titleLabel.text = "Emoji"
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            return view
        } else if collectionView == сolorsCollectionView {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {
                return UICollectionReusableView()
            }
            view.titleLabel.text = Localizable.newHabitColor
            view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
            return view
        }
        return UICollectionReusableView()
    }
}

extension NewHabitViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            if mode == .edit {
                deselectCellEmojiEditMode()
            }
            
            selectEmoji = emoji[indexPath.row]
            checkAndUpdateCreateButton()
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.backgroundColor = UIColor(named: "superLightGray2")
            }
        } else if collectionView == сolorsCollectionView {
            if mode == .edit {
                deselectCellColorsEditMode()
            }
            
            selectColor = colors[indexPath.row] ?? UIColor()
            checkAndUpdateCreateButton()
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.layer.borderWidth = 3
                cell.layer.borderColor = colors[indexPath.row]?.withAlphaComponent(0.3).cgColor
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = .systemBackground
            cell.layer.borderWidth = 0
        }
    }
}

extension NewHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == emojiCollectionView {
            return CGSize(width: 52, height: 52)
        } else if collectionView == сolorsCollectionView {
            return CGSize(width: 52, height: 52)
        }
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == emojiCollectionView {
            return 5
        } else if collectionView == сolorsCollectionView {
            return 5
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == emojiCollectionView {
            return 0
        } else if collectionView == сolorsCollectionView {
            return 0
        }
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == emojiCollectionView {
            return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        } else if collectionView == сolorsCollectionView {
            return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
        }
        return UIEdgeInsets()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 18)
    }
}

extension NewHabitViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = 38
        let currentString: NSString = trackerNameTextField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLenght
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        trackerNameTextField.resignFirstResponder()
        return true
    }
}

