//
//  Colors.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 10.08.2024.
//

import UIKit

final class Colors {
    static let viewBackgroundColor = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return UIColor.white
        } else {
            return UIColor(named: "darkGray") ?? UIColor()
        }
    }
}
