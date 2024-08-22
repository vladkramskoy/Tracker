//
//  CategoriesViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 28.06.2024.
//

import UIKit

final class CategoriesViewController: UIViewController {
    private let viewModel: CategoriesViewModelProtocol
    
    private lazy var stubImage: UIImageView = {
        let stubImage = UIImageView()
        stubImage.image = UIImage(named: "stubImage")
        stubImage.translatesAutoresizingMaskIntoConstraints = false
        return stubImage
    }()
    
    private lazy var stubLabel: UILabel = {
        let stubLabel = UILabel()
        stubLabel.text = Localizable.categoriesStub
        stubLabel.numberOfLines = 2
        stubLabel.font = UIFont.systemFont(ofSize: 12)
        stubLabel.textAlignment = .center
        stubLabel.translatesAutoresizingMaskIntoConstraints = false
        return stubLabel
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let addCategoryButton = UIButton(type: .system)
        addCategoryButton.setTitle(Localizable.categoriesAddButton, for: .normal)
        addCategoryButton.tintColor = UIColor(named: "white&dark(darkMode)")
        addCategoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        addCategoryButton.layer.cornerRadius = 16
        addCategoryButton.backgroundColor = UIColor(named: "dark&white(darkMode)")
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        return addCategoryButton
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = UIColor(named: "customGray")
        tableView.backgroundColor = Colors.viewBackgroundColor
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    init(viewModel: CategoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.viewBackgroundColor
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
        view.addSubview(tableView)
        view.addSubview(addCategoryButton)
        setupConstraints()
        tableView.register(CategoriesCustomTableViewCell.self, forCellReuseIdentifier: "customCell")
        addCategoryButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        tableView.delegate = self
        tableView.dataSource = self
        setupBindings()
        viewModel.updateUI()
        setupNotification()
        viewModel.handleViewDidLoad()
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
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
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
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: Notification.Name("NewCategoryAdded"), object: nil)
    }
    
    private func cellDidTapped() {
        viewModel.cellDidTapped()
        presentingViewController?.dismiss(animated: true)
    }
    
    private func setupBindings() {
        viewModel.onCategoriesUpdated = { [weak self] isStubVisible, isTableVisible in
            self?.stubImage.isHidden = !isStubVisible
            self?.stubLabel.isHidden = !isStubVisible
            self?.tableView.isHidden = !isTableVisible
            self?.tableView.reloadData()
        }
    }
    
    @objc private func addCategoryButtonTapped() {
        viewModel.triggerFeedback()
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.title = Localizable.newCategoryTitle
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func updateData() {
        viewModel.updateUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CategoriesCustomTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = viewModel.filteredCategories[indexPath.row].name
        cell.backgroundColor = UIColor(named: "superLightGray(darkMode)")
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            cell.layer.maskedCorners = []
        }
        
        let category = viewModel.filteredCategories[indexPath.row]
        if let selectedCategoryName = CategoriesViewModel.selectedCategory?.name, selectedCategoryName == category.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
}

extension CategoriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPath = CategoriesViewModel.selectedIndexPath {
            let previousCell = tableView.cellForRow(at: selectedIndexPath)
            previousCell?.accessoryType = .none
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRowAt(indexPath.row)
        
        cellDidTapped()
        // TODO: Реализовать логику удаления категорий
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let insetAmount: CGFloat = 16.0
        
        if indexPath.row == viewModel.filteredCategories.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}
