//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 20.06.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    private lazy var createHabitButton: UIButton = {
        let createHabitButton = UIButton()
        createHabitButton.setTitle("Привычка", for: .normal)
        createHabitButton.layer.cornerRadius = 16
        createHabitButton.backgroundColor = UIColor(named: "darkGray")
        createHabitButton.translatesAutoresizingMaskIntoConstraints = false
        return createHabitButton
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let createIrregularEventButton = UIButton()
        createIrregularEventButton.setTitle("Нерегулярное событие", for: .normal)
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
}
