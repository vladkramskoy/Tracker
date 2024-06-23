//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 20.06.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    private lazy var createHabitButton: UIButton = {
        let createHabitButton = UIButton(type: .system)
        createHabitButton.setTitle("Привычка", for: .normal)
        createHabitButton.tintColor = .white
        createHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createHabitButton.addTarget(self, action: #selector(createHabitButtonTapped), for: .touchUpInside)
        createHabitButton.layer.cornerRadius = 16
        createHabitButton.backgroundColor = UIColor(named: "darkGray")
        createHabitButton.translatesAutoresizingMaskIntoConstraints = false
        return createHabitButton
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let createIrregularEventButton = UIButton(type: .system)
        createIrregularEventButton.setTitle("Нерегулярное событие", for: .normal)
        createIrregularEventButton.tintColor = .white
        createIrregularEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        createIrregularEventButton.addTarget(self, action: #selector(createIrregularEventButtonTapped), for: .touchUpInside)
        createIrregularEventButton.layer.cornerRadius = 16
        createIrregularEventButton.backgroundColor = UIColor(named: "darkGray")
        createIrregularEventButton.translatesAutoresizingMaskIntoConstraints = false
        return createIrregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(createHabitButton)
        view.addSubview(createIrregularEventButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createHabitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 395),
            createHabitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createHabitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createHabitButton.heightAnchor.constraint(equalToConstant: 60),
            
            createIrregularEventButton.topAnchor.constraint(equalTo: createHabitButton.bottomAnchor, constant: 16),
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func createHabitButtonTapped() {
        let newHabitViewController = NewHabitViewController()
        newHabitViewController.title = "Новая привычка"
        let navigationController = UINavigationController(rootViewController: newHabitViewController)
        present(navigationController, animated: true)
    }
    
    @objc private func createIrregularEventButtonTapped() {
        let newIrregularEventViewController = NewIrregularEventViewController()
        newIrregularEventViewController.title = "Новое нерегулярное событие"
        let navigationController = UINavigationController(rootViewController: newIrregularEventViewController)
        present(navigationController, animated: true)
    }
}
