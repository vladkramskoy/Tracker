//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 28.06.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    private var selectedIndexPath: IndexPath?
    static var selectedCategory: String? = nil

    private lazy var stubImage: UIImageView = {
        let stubImage = UIImageView()
        stubImage.image = UIImage(named: "stubImage")
        stubImage.translatesAutoresizingMaskIntoConstraints = false
        return stubImage
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.text = "Привычки и события можно\nобъединить по смыслу"
        stubLabel.numberOfLines = 2
        stubLabel.font = UIFont.systemFont(ofSize: 12)
        stubLabel.textAlignment = .center
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        return stubLabel
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton(type: .system)
        addCategoryButton.setTitle("Добавить категорию", for: .normal)
        addCategoryButton.tintColor = .white
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.backgroundColor = UIColor(named: "darkGray")
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        return addCategoryButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        setupConstraints()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addCategoryButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tableView.delegate = self
        tableView.dataSource = self
        updateUI()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -44),
            
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    private func updateUI() {
        if TrackersViewController.categories.isEmpty {
            stubImage.isHidden = false
            stubLabel.isHidden = false
        } else {
            stubImage.isHidden = true
            stubLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    private func cellDidTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("CategoryDidSelected"), object: nil)
    }
    
    @objc private func addCategoryButtonTapped() {
        print("addCategoryButtonTapped")
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackersViewController.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = TrackersViewController.categories[indexPath.row].name
        if let selectedIndexPath = selectedIndexPath, selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = selectedIndexPath {
            let previousCell = tableView.cellForRow(at: selectedIndexPath)
            previousCell?.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndexPath = indexPath
        CategoryViewController.selectedCategory = TrackersViewController.categories[indexPath.row].name
        
        cellDidTapped()
        // TODO: Реализовать логику удаления категорий
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == TrackersViewController.categories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
    }
}
