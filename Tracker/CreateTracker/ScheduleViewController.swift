//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 25.06.2024.
//

import UIKit

final class ScheduleViewController: UIViewController {
    static var selectedDays: String? = nil
    static var schedule: [WeekDay: Bool] = [:]
    private let weekDay = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Готово", for: .normal)
        doneButton.tintColor = .white
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        doneButton.layer.cornerRadius = 16
        doneButton.backgroundColor = UIColor(named: "darkGray")
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        return doneButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializingSchedule()
        view.backgroundColor = .white
        doneButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        view.addSubview(doneButton)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupConstraints()
        feedbackGenerator.prepare()
    }
    
    private func initializingSchedule() {
        for day in WeekDay.allCases {
            ScheduleViewController.schedule[day] = false
        }
    }
    
    private func filteringSelectedDays() {
        ScheduleViewController.selectedDays = ScheduleViewController.schedule.filter { $0.value }.map { $0.key.rawValue }.joined(separator: ", ")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 335)
        ])
    }
    
    @objc private func doneButtonTapped() {
        feedbackGenerator.impactOccurred()
        filteringSelectedDays()
        NotificationCenter.default.post(name: NSNotification.Name("ScheduleDidCreated"), object: nil)
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc private func switchChanged(_ sender: UISwitch) {
        let weekDay = WeekDay.allCases
        if sender.tag < weekDay.count {
            let day = weekDay[sender.tag]
            ScheduleViewController.schedule[day] = sender.isOn
        }
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor(named: "superLightGray")
        
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        cell.accessoryView = switchView
        cell.textLabel?.text = weekDay[indexPath.row]
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == weekDay.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        } else {
            cell.separatorInset = .zero
        }
    }
}
