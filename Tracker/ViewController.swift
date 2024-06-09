//
//  ViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 07.06.2024.
//

import UIKit

final class ViewController: UIViewController {
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
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -105)
            
        ])
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
    }
}

