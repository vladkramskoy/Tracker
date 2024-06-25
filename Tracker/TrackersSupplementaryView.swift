//
//  TrackersSupplementaryView.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 23.06.2024.
//

import UIKit

class TrackersSupplementaryView: UICollectionReusableView {
    static let identifier = "header"
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -28),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
