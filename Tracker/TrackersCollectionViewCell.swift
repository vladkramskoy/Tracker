//
//  TrackersCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 23.06.2024.
//

import UIKit

final class TrackersCollectionViewCell: UICollectionViewCell {
    static let identifier = "cell"
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        contentView.backgroundColor = .lightGray // DEL
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
