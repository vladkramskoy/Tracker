//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 23.06.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier = "cell"
    let cardView = UIView()
    let iconLabel = UILabel()
    let textLabel = UILabel()
    let periodLabel = UILabel()
    let completeButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        contentView.addSubview(periodLabel)
        cardView.addSubview(completeButton)
        cardView.addSubview(iconLabel)
        cardView.addSubview(textLabel)
        
        cardView.backgroundColor = UIColor(named: "green")
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        iconLabel.backgroundColor = .white.withAlphaComponent(0.3)
        iconLabel.layer.masksToBounds = true
        iconLabel.layer.cornerRadius = 12
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.text = "Поливать растения"
        textLabel.numberOfLines = 2
        textLabel.textColor = .white
        textLabel.font = UIFont.systemFont(ofSize: 13)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        configureTextLabel()
        
        periodLabel.text = "1 день"
        periodLabel.font = UIFont.systemFont(ofSize: 12)
        periodLabel.translatesAutoresizingMaskIntoConstraints = false
        
        completeButton.setImage(UIImage(systemName: "plus"), for: .normal)
        completeButton.backgroundColor = cardView.backgroundColor
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        completeButton.tintColor = .white
        completeButton.layer.cornerRadius = 17
        completeButton.layer.masksToBounds = true
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            iconLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            iconLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            iconLabel.heightAnchor.constraint(equalToConstant: 24),
            iconLabel.widthAnchor.constraint(equalToConstant: 24),
            
            textLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 44),
            textLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            textLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            periodLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            periodLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            periodLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
            periodLabel.widthAnchor.constraint(equalToConstant: 101),
            
            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTextLabel() {
        guard let text = textLabel.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        let lineHeight: CGFloat = 17
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        textLabel.attributedText = attributedString
    }
    
    @objc private func completeButtonTapped() {
        print("completeButtonTapped")
    }
}
