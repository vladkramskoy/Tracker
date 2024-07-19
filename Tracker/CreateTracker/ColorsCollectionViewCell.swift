//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 04.07.2024.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    static let identifier = "colorCell"
    var cellView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cellView.layer.cornerRadius = 8
        cellView.layer.masksToBounds = true
        cellView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellView.widthAnchor.constraint(equalToConstant: 40),
            cellView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
