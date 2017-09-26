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

    override func draw(_ rect: CGRect) {
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
