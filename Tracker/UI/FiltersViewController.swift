//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 15.08.2024.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func showAllTrackers()
    func filterTrackers(for date: Date)
    func filterCompletedTrackers(showCompleted: Bool)
}

final class FiltersViewController: UIViewController {
    private let filters = [Localizable.filtersAllTrackers, Localizable.filtersTrackersForToday, Localizable.filtersCompleted, Localizable.filtersNotCompleted]
    weak var delegate: FiltersViewControllerDelegate?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = UIView()
        tableView.separatorColor = UIColor(named: "customGray")
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(delegate: FiltersViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.viewBackgroundColor
        view.addSubview(tableView)
        setupConstraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = filters[indexPath.row]
        cell.backgroundColor = UIColor(named: "superLightGray(darkMode)")
        
        let selectedCellIndex = UserDefaults.standard.integer(forKey: "selectedFilter")
        cell.accessoryType = (indexPath.row == selectedCellIndex) ? .checkmark : .none
        
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let previousSelectedIndex = UserDefaults.standard.value(forKey: "selectedFilter") as? Int {
            let previousIndexPath = IndexPath(row: previousSelectedIndex, section: 0)
            if let previousCell = tableView.cellForRow(at: previousIndexPath) {
                previousCell.accessoryType = .none
            }
        }
        
        if let currentCell = tableView.cellForRow(at: indexPath) {
            currentCell.accessoryType = .checkmark
        }
        UserDefaults.standard.set(indexPath.row, forKey: "selectedFilter")
        
        switch indexPath.row {
        case 0:
            delegate?.showAllTrackers()
        case 1:
            delegate?.filterTrackers(for: Date())
        case 2:
            delegate?.filterCompletedTrackers(showCompleted: true)
        case 3:
            delegate?.filterCompletedTrackers(showCompleted: false)
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        presentingViewController?.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let insetAmount: CGFloat = 16.0
        
        if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}
