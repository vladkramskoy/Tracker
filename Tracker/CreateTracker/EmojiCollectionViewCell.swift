//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 03.07.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let identifier = "emojiCell"
    var emojiLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
