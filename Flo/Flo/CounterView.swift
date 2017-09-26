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
    
    @IBInspectable var count: Int = 5 {
        didSet {
            if count <= Constants.numberOfGlasses {
                //view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
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
        
        //Counter View markers
        let context = UIGraphicsGetCurrentContext()
        
        //save original state
        context?.saveGState()
        outlineColor.setFill()
        
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        
        //marker rectangle positioned at the top left
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
        
        //move top left of context to the previous center position
        context?.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...Constants.numberOfGlasses {
            //save the centred context
            context?.saveGState()
            
            //calculate the rotation angle
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            
            //rotate and translate
            context?.rotate(by: angle)
            context?.translateBy(x: 0, y: rect.height / 2 - markerSize)
            
            //fill the marker rectangle
            markerPath.fill()
            
            //restore the centred context for the next rotate
            context?.restoreGState()
        }
        
        //restore the original state
        context?.restoreGState()
    }

}
