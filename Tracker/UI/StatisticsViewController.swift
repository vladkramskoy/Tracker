//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 21.08.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {
    var data: [TrackerData] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Colors.viewBackgroundColor
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        data.isEmpty ? showPlaceholder() : ()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Localizable.statisticsTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Colors.viewBackgroundColor
        view.addSubview(tableView)
        setupConstraints()

        data = [
            TrackerData(title: Localizable.statisticsBestPeriod, value: 6),
            TrackerData(title: Localizable.statisticsPerfectDays, value: 2),
            TrackerData(title: Localizable.statisticsTrackersСompleted, value: 5),
            TrackerData(title: Localizable.statisticsAverageValue, value: 4)
        ]
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 1000)
        ])
    }
    
    private func showPlaceholder() {
        let placeholderImage = UIImageView()
        placeholderImage.image = UIImage(named: "statisticsPlaceholder")
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderImage)
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Анализировать пока нечего"
        placeholderLabel.font = UIFont.systemFont(ofSize: 12)
        placeholderLabel.textAlignment = .center
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderImage.heightAnchor.constraint(equalToConstant: 80),
            placeholderImage.widthAnchor.constraint(equalToConstant: 80),
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        let gradientView = GradientBorderView(frame: cell.contentView.bounds)
            gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            gradientView.addGradientBorder(
                colors: [
                    UIColor(red: 253.0/255.0, green: 76.0/255.0, blue: 73.0/255.0, alpha: 1.0).cgColor,
                    UIColor(red: 70.0/255.0, green: 230.0/255.0, blue: 157.0/255.0, alpha: 1.0).cgColor,
                    UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 250.0/255.0, alpha: 1.0).cgColor,
                ],
                lineWidth: 3,
                cornerRadius: 16
            )
            
            cell.contentView.addSubview(gradientView)
        
        
        let trackerData = data[indexPath.section]
        
        cell.backgroundColor = .brown
        cell.backgroundColor = Colors.viewBackgroundColor
        cell.textLabel?.text = "\(trackerData.value)"
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 34)
        cell.detailTextLabel?.text = trackerData.title
        
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = Colors.viewBackgroundColor.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
}

