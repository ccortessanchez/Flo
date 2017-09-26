//
//  GraphView.swift
//  Flo
//
//  Created by Carlos Cortés Sánchez on 26/09/2017.
//  Copyright © 2017 Carlos Cortés Sánchez. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIView {
    
    //start and end colors for gradient
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green

    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60.0
        static let bottomBorder: CGFloat = 50.0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        //obtain current context
        //CG drawing methods need a context in order to draw
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.cgColor, endColor.cgColor]
        
        //all contexts have a color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        //color stops describe where the colors in the gradient change over
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        //create the actual gradient, defining the color space, colors and color stops
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
        
        //draw the gradient
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x:0, y: bounds.height)
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
    }

}
