//
//  ViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit

final class TrackersListViewController: UIViewController {
    private lazy var addTrackerButton: UIButton = {
        let addTrackerButton = UIButton.systemButton(with: UIImage(named: "plusIcon") ?? UIImage(), target: nil, action: nil)
        addTrackerButton.translatesAutoresizingMaskIntoConstraints = false
        return addTrackerButton
    }()
    
    private lazy var datePickerButton: UIButton = {
        let datePickerButton = UIButton()
        datePickerButton.setTitle("14.12.22", for: .normal)
        datePickerButton.setTitleColor(.black, for: .normal)
        datePickerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        datePickerButton.translatesAutoresizingMaskIntoConstraints = false
        return datePickerButton
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 34)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var searchField: UISearchTextField = {
        let searchField = UISearchTextField()
        searchField.text = "Поиск"
        searchField.textColor = UIColor(named: "Gray")
        searchField.translatesAutoresizingMaskIntoConstraints = false
        return searchField
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubview()
        setupConstraints()
        setupAppearance()
    }
    
    private func setupSubview() {
        view.addSubview(addTrackerButton)
        view.addSubview(datePickerButton)
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(stubImage)
        view.addSubview(stubLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            addTrackerButton.heightAnchor.constraint(equalToConstant: 42),
            addTrackerButton.widthAnchor.constraint(equalToConstant: 42),
            addTrackerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addTrackerButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
            
            datePickerButton.heightAnchor.constraint(equalToConstant: 34),
            datePickerButton.widthAnchor.constraint(equalToConstant: 77),
            datePickerButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            datePickerButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -105),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            searchField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            
            stubImage.heightAnchor.constraint(equalToConstant: 80),
            stubImage.widthAnchor.constraint(equalToConstant: 80),
            stubImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stubImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 44),
            
            stubLabel.heightAnchor.constraint(equalToConstant: 18),
            stubLabel.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
            stubLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            stubLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
        
        if let iconView = searchField.leftView as? UIImageView {
            let tintedImage = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.image = tintedImage
            iconView.tintColor = UIColor(named: "Gray")
        }
    }
}

