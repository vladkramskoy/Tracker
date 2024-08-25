//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 28.06.2024.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private lazy var textFieldView: UIView = {
        let textFieldView = UIView()
        textFieldView.backgroundColor = UIColor(named: "superLightGray(darkMode)")
        textFieldView.layer.cornerRadius = 16
        textFieldView.layer.masksToBounds = true
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        return textFieldView
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let categoryNameTextField = UITextField()
        categoryNameTextField.placeholder = Localizable.newCategoryNameField
        categoryNameTextField.addTarget(self, action: #selector(textFieldDidChange(_ :)), for: .editingChanged)
        categoryNameTextField.translatesAutoresizingMaskIntoConstraints = false
        return categoryNameTextField
    }()
    
    private lazy var doneButton: UIButton = {
        let doneButton = UIButton(type: .system)
        doneButton.setTitle(Localizable.newCategoryDoneButton, for: .normal)
        doneButton.tintColor = .white
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        doneButton.layer.cornerRadius = 16
        doneButton.backgroundColor = UIColor(named: "customGray")
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.isEnabled = false
        return doneButton
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        return tapGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.viewBackgroundColor
        view.addSubview(textFieldView)
        view.addSubview(categoryNameTextField)
        view.addSubview(doneButton)
        setupConstraints()
        doneButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        categoryNameTextField.delegate = self
        view.addGestureRecognizer(tapGesture)
        feedbackGenerator.prepare()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            textFieldView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            textFieldView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textFieldView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textFieldView.heightAnchor.constraint(equalToConstant: 75),
            
            categoryNameTextField.topAnchor.constraint(equalTo: textFieldView.topAnchor),
            categoryNameTextField.leadingAnchor.constraint(equalTo: textFieldView.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: textFieldView.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.widthAnchor.constraint(equalToConstant: 335),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = categoryNameTextField.text, !text.isEmpty {
            doneButton.isEnabled = true
            doneButton.backgroundColor = UIColor(named: "dark&white(darkMode)")
            doneButton.tintColor = UIColor(named: "white&dark(darkMode)")
        } else {
            doneButton.isEnabled = false
            doneButton.backgroundColor = UIColor(named: "customGray")
            doneButton.tintColor = .white
        }
    }
    
    @objc private func doneButtonTapped() {
        feedbackGenerator.impactOccurred()
        guard let text = categoryNameTextField.text, !text.isEmpty else { return }
        let newCategory = TrackerCategory(name: text, trackers: [])

        do {
            try trackerCategoryStore.addNewCategory(newCategory)
        } catch {
            print("Failed to add a category: \(error)")
        }
        NotificationCenter.default.post(name: NSNotification.Name("NewCategoryAdded"), object: nil)
        presentingViewController?.dismiss(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = 38
        let currentString: NSString = categoryNameTextField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLenght
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        categoryNameTextField.resignFirstResponder()
        return true
    }
}

