//
//  ColorsCollectionViewCell.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 04.07.2024.
//

import UIKit

final class ColorsCollectionViewCell: UICollectionViewCell {
    static let identifier = "colorCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
