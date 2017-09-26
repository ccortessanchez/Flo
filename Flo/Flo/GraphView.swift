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
    
    //weekly sample data
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]

    private struct Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60.0
        static let bottomBorder: CGFloat = 50.0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
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
        
        //calculate the x point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            //calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        
        //calculate the y point
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.max()!
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - y //flip the graph
        }
        
        //draw the line graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        //setup the points line
        let graphPath = UIBezierPath()
        
        //go to start of line
        graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        //add points for each item in the graphPoints array
        //at the correct (x,y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        //Create the clipping path for the graph gradient
        //save state of the context
        //context.saveGState()
        
        //make a copy of the path
        let clippingPath = graphPath.copy() as! UIBezierPath
        
        //add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        
        //add the clipping path to the context
        clippingPath.addClip()
        
        //check clipping path
        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        context?.drawLinearGradient(gradient!, start: graphStartPoint, end: graphEndPoint, options: [])
        //context?.restoreGState()
        
        //draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
    }

}
