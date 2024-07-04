//
//  NewIrregularEventViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 22.06.2024.
//

import UIKit

final class NewIrregularEventViewController: UIViewController {
    private var cellTitles: [(String, String?)] = [("Категория", nil)] {
        didSet {
            checkAndUpdateCreateButton()
        }
    }
    private let emoji: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private var selectEmoji = ""
    
    private lazy var textFieldView: UIView = {
        let textFieldView = UIView()
        textFieldView.backgroundColor = UIColor(named: "superLightGray")
        textFieldView.layer.cornerRadius = 16
        textFieldView.layer.masksToBounds = true
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()
    
    private lazy var trackerNameTextField: UITextField = {
        let trackerNameTextField = UITextField()
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingChanged)
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return trackerNameTextField
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        emojiCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        emojiCollectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return emojiCollectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Отмена", for: .normal)
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
        createButton.setTitle("Создать", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textFieldView)
        view.addSubview(trackerNameTextField)
        view.addSubview(tableView)
        view.addSubview(emojiCollectionView)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        tableView.delegate = self
        tableView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.dataSource = self
        trackerNameTextField.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupConstraints()
        setupNotificationObserver()
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func cancelButtonTapped() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        guard let text = trackerNameTextField.text, !text.isEmpty else { return }
        if let selectedCategory = CategoryViewController.selectedCategory {
            let schedule: [WeekDay: Bool] = [
                .monday: true,
                .tuesday: true,
                .wednesday: true,
                .thursday: true,
                .friday: true,
                .saturday: true,
                .sunday: true
            ]
            let newTracker = Tracker(id: UUID(), name: text, color: .black, emoji: selectEmoji, schedule: schedule)
            let updateCategory = selectedCategory.addingTracker(newTracker)
            TrackersViewController.categories.append(updateCategory)
            NotificationCenter.default.post(name: NSNotification.Name("TrackerCreated"), object: nil)
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func updateTableView() {
        DispatchQueue.main.async {
            self.cellTitles = [("Категория", "\(CategoryViewController.selectedCategoryString ?? "")")]
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
        if let text = trackerNameTextField.text, !text.isEmpty, cellTitles[0].1 != nil {
            createButton.isEnabled = true
            createButton.backgroundColor = UIColor(named: "darkGray")
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = UIColor(named: "customGray")
        }
    }
    
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: NSNotification.Name("CategoryDidSelected"), object: nil)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            
            trackerNameTextField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            trackerNameTextField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            trackerNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            tableView.topAnchor.constraint(equalTo: trackerNameTextField.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 32),
            emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            
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

extension NewIrregularEventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = cellTitles[indexPath.row].0
        cell.detailTextLabel?.text = cellTitles[indexPath.row].1
        cell.detailTextLabel?.textColor = UIColor(named: "customGray")
        cell.backgroundColor = UIColor(named: "superLightGray")
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension NewIrregularEventViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let categoryViewController = CategoryViewController()
            categoryViewController.title = "Категория"
            let navigationController = UINavigationController(rootViewController: categoryViewController)
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
        if indexPath.row == cellTitles.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
    }
}

extension NewIrregularEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = emojiCollectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.emojiLabel.font = UIFont.systemFont(ofSize: 32)
        cell.emojiLabel.text = emoji[indexPath.row]
        if emojiCollectionView.indexPathsForSelectedItems?.contains(indexPath) == true {
            cell.contentView.backgroundColor = .lightGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        view.titleLabel.text = "Emoji"
        view.titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        return view
    }
}

extension NewIrregularEventViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        emojiCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        selectEmoji = emoji[indexPath.row]
        print("Test \(indexPath.row)")
    }
}

extension NewIrregularEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 24, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(emojiCollectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
}

extension NewIrregularEventViewController: UITextFieldDelegate {
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

