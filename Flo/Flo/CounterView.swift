//
//  CounterView.swift
//  Flo
//
//  Created by Carlos Cortés Sánchez on 25/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import UIKit

@IBDesignable class CounterView: UIView {
    
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth/2
        }
    }
    
    @IBInspectable var count: Int = 5
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    override func draw(_ rect: CGRect) {
        //define center point of the view where we rotate the arc around
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        
        //calculate radius based on max dimension of view
        let radius: CGFloat = max(bounds.width, bounds.height)
        
        //define start and end angles for arc
        let startAngle: CGFloat = 3 * .pi/4
        let endAngle: CGFloat = .pi/4
        
        //create path based on center point, radius and angles defined above
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - Constants.arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //set line width and color before setting the stroke
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //Draw the outline
        //calculate the difference between two angles ensuring it's positive
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        
        //calculate the arc for each single glass
        let arcLengthPerGlass = angleDifference/CGFloat(Constants.numberOfGlasses)
        
        //multiply by the glasses drunk
        let outlineEndAngle = arcLengthPerGlass * CGFloat(count) + startAngle
        
        //draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center, radius: bounds.width/2 - Constants.halfOfLineWidth, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)
        
        //draw the inner arc
        outlinePath.addArc(withCenter: center, radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
        
        //close the path
        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
    }

}
