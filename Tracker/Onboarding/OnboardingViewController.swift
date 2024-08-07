//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 29.07.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {
    private let backgroundImage: UIImage
    private let onboardingText: String
    
    private lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = onboardingText
        textLabel.numberOfLines = 2
        textLabel.font = UIFont.boldSystemFont(ofSize: 32)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    init(backgroundImage: UIImage, onboardingText: String) {
        self.backgroundImage = backgroundImage
        self.onboardingText = onboardingText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        view.addSubview(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
    }
    
    private func setBackground() {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = backgroundImage
        imageView.contentMode = .scaleAspectFill
        view.insertSubview(imageView, at: 0)
    }
}
