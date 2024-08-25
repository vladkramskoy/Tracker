//
//  GradientBorderView.swift
//  Tracker
//
//  Created by Vladislav Kramskoy on 21.08.2024.
//

import UIKit

class GradientBorderView: UIView {
    private var gradientLayer: CAGradientLayer?
    
    func addGradientBorder(colors: [CGColor], lineWidth: CGFloat, cornerRadius: CGFloat) {
        gradientLayer?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        maskLayer.lineWidth = lineWidth
        
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
        
        updateGradientLayer(lineWidth: lineWidth, cornerRadius: cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientLayer(lineWidth: 2, cornerRadius: 16)
    }
    
    private func updateGradientLayer(lineWidth: CGFloat, cornerRadius: CGFloat) {
        gradientLayer?.frame = self.bounds
        
        let path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2), cornerRadius: cornerRadius)
        
        if let maskLayer = gradientLayer?.mask as? CAShapeLayer {
            maskLayer.path = path.cgPath
        } else {
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            maskLayer.fillColor = UIColor.clear.cgColor
            maskLayer.strokeColor = UIColor.black.cgColor
            maskLayer.lineWidth = lineWidth
            
            gradientLayer?.mask = maskLayer
        }
    }
}
