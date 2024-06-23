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
        self.backgroundColor = .brown // DEL
        titleLabel.backgroundColor = .blue // DEL
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
