[![Platform](http://img.shields.io/badge/platform-ios-blue.svg)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-yellow.svg)](https://developer.apple.com/swift)
[![Version](http://img.shields.io/badge/version-4.0-orange.svg)](#)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://mit-license.org)

# Flo

# Table of contents
* [Description](#description)
* [Requirements](#requirements)
* [Built with](#built-with)
* [Getting started](#getting-started)
  * [Custom drawing on views](#custom-drawing-on-views)
    * [Example: Plus button](#plus-button-example)
  * [Custom storyboard properties](#custom-storyboard-properties)
    * [Example: Inspectable variables](#inspectable-variable-examples)
  * [Result](#result)
* [Gradients and contexts](#gradients-and-contexts)
  * [Create graph view](#create-graph-view)
  * [Animation transition](#animation-transition)
  * [Draw a gradient](#draw-a-gradient)
  * [Clipping areas](#clipping-areas)
  * [Calculate graph points](#calculate-graph-points)
  * [Gradient graph](#gradient-graph)
  * [Draw data points](#draw-data-points)
  * [Context states](#context-states)
  * [Add labels to the graph](#add-labels-to-the-graph)
  * [Result](#Result)
* [Patterns and playgrounds](#patterns-and-playgrounds)
* [License](#license)
***

## Description
App for tracking drinking habits. Part of Raywenderlich Core Graphics tutorial series
* Part 1: [Getting started](https://www.raywenderlich.com/162315/core-graphics-tutorial-part-1-getting-started)
* Part 2: [Gradients and contexts](https://www.raywenderlich.com/162313/core-graphics-tutorial-part-2-gradients-contexts)
* Part 3: [Patterns and playgrounds](https://www.raywenderlich.com/167352/core-graphics-tutorial-part-3-patterns-playgrounds)
***

## Requirements
* iOS 11.0
* Swift 4.0
***

## Built with
* [Core Graphics](https://developer.apple.com/documentation/coregraphics)
* [IBDesignable/IBInspectable](http://nshipster.com/ibinspectable-ibdesignable/)

***
## Getting started
### Custom drawing on views
1. Create a *UIView* subclass
2. Override *draw()* and add some custom Core Graphics

### Plus button example
1. Create a new class *PushButton.swift* and make it a subclass of *UIView*
2. Add a button to the storyboard. In the *Identity Inspector*, change *UIButton* class for *PushButton*
3. Add Auto-Layout constraints to the button
4. Draw the shape of the button (circle button) in *PushButton.swift*
```swift
override func draw(_ rect: CGRect) {
  let path = UIBezierPath(ovalIn: rect)
  UIColor.green.setFill()
  path.fill()
}
```
5. Add the next snipplet before *PushButton* class declaration to enable **Live Rendering**
```swift
@IBDesignable
```
6. Add these struct and constants inside *PushButton*
```swift
private struct Constants {
  static let plusLineWidth: CGFloat = 3.0
  static let plusButtonScale: CGFloat = 0.6
  static let halfPointShift: CGFloat = 0.5
}
  
private var halfWidth: CGFloat {
  return bounds.width / 2
}
  
private var halfHeight: CGFloat {
  return bounds.height / 2
}
```
7. At the end of *draw()*, set up the width and height variables for the horizontal stroke
```swift
let plusWidth: CGFloat = min(bounds.width, bounds.height) * Constants.plusButtonScale
let halfPlusWidth = plusWidth / 2
```
8. Create the path and set the path's line width to the height of the stroke
```swift
let plusPath = UIBezierPath()
plusPath.lineWidth = Constants.plusLineWidth
```
9. Move the initial point of the path to the start of the horizontal stroke and add a point to the path at the end of the stroke
```swift
plusPath.move(to: CGPoint(
  x: halfWidth - halfPlusWidth + Constants.halfPointShift,
  y: halfHeight + Constants.halfPointShift))
  
plusPath.addLine(to: CGPoint(
  x: halfWidth + halfPlusWidth + Constants.halfPointShift,
  y: halfHeight + Constants.halfPointShift))
```
10.Same for the vertical line
```swift
plusPath.move(to: CGPoint(
  x: halfWidth + Constants.halfPointShift,
  y: halfHeight - halfPlusWidth + Constants.halfPointShift))
      
plusPath.addLine(to: CGPoint(
  x: halfWidth + Constants.halfPointShift,
  y: halfHeight + halfPlusWidth + Constants.halfPointShift))
```
11. Set the stroke color and draw it
```swift
UIColor.white.setStroke()
plusPath.stroke()
```

### Custom storyboard properties
```swift
@IBInspectable var variableName: VariableType = variableValue
```
### Inspectable variable examples
1. Add some variables to a IBDesignable class
```swift
@IBInspectable var fillColor: UIColor = UIColor.green
@IBInspectable var isAddButton: Bool = true
```
2. Storyboard *Attributes Inspector* should show the custom variables
<p align="left">
<img width="300" height="270" src="https://github.com/ccortessanchez/Flo/blob/master/Screenshots/IBInspectable_button.png">
</p>

### Arcs with UIBezierPath
#### Drawing arcs
1. Create a new class *CounterView.swift* and make it subclass of *UIView*. Add the next code to *CounterView*
```swift
@IBDesignable class CounterView: UIView {
  
  private struct Constants {
    static let numberOfGlasses = 8
    static let lineWidth: CGFloat = 5.0
    static let arcWidth: CGFloat = 76
    
    static var halfOfLineWidth: CGFloat {
      return lineWidth / 2
    }
  }
  
  @IBInspectable var counter: Int = 5
  @IBInspectable var outlineColor: UIColor = UIColor.blue
  @IBInspectable var counterColor: UIColor = UIColor.orange
  
  override func draw(_ rect: CGRect) {
    
  }
}
```
2. Add a view to the storyboard. In the *Identity Inspector* change *UIView* class for *CounterView*
3. Add Auto-Layout constraints to the view
4. In *draw()*, define the center point of the view where you’ll rotate the arc around
```swift
let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
```
5. Calculate the radius based on view's max dimension
```swift
let radius: CGFloat = max(bounds.width, bounds.height)
```
6. Define start and end angles for the arc
```swift
let startAngle: CGFloat = 3 * .pi / 4
let endAngle: CGFloat = .pi / 4
```
7. Create a path based on the center point, radius, and angles defined
```swift
let path = UIBezierPath(arcCenter: center,
                           radius: radius/2 - Constants.arcWidth/2,
                       startAngle: startAngle,
                         endAngle: endAngle,
                        clockwise: true)
```
8. Set the line width and color before finally stroking the path
```swift
path.lineWidth = Constants.arcWidth
counterColor.setStroke()
path.stroke()
```

#### Outlining the arc
1. At the end of *draw()*, calculate the difference between the two angles
```swift
let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
```
2. Calculate the arc for each glass and multiply by the actual glasses drunk
```swift
let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
```
3. Draw the outer arc
```swift
let outlinePath = UIBezierPath(arcCenter: center,
                                  radius: bounds.width/2 - Constants.halfOfLineWidth,
                              startAngle: startAngle,
                                endAngle: outlineEndAngle,
                               clockwise: true)
```
4. Draw the inner arc
```swift
outlinePath.addArc(withCenter: center,
                       radius: bounds.width/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                   startAngle: outlineEndAngle,
                     endAngle: startAngle,
                    clockwise: false)
```
5. Close the path
```swift
outlinePath.close()
    
outlineColor.setStroke()
outlinePath.lineWidth = Constants.lineWidth
outlinePath.stroke()
```

### Result
<p align="left">
<img width="240" height="450" src="https://github.com/ccortessanchez/Flo/blob/master/Screenshots/View_EndPart1.png">
</p>

***
## Gradients and contexts
### Create graph view
1. Add a view to the storyboard above the *Counter View* created in [part 1, step 2](#drawing-arcs). Change it's background color to make it visible. Change his name for *Container View*
2. Add Auto-Layout constraints to the view
3. Create a new class *GraphView.swift* and make a subclass of *UIView*
4. Add a view to the storyboard below the *Counter View*. In the *Identity Inspector* change *UIView* class for *GraphView*
5. Add Auto-Layout constraints to the view
6. **Document Outline** should look like this

<p align="left">
<img width="300" height="300" src="https://github.com/ccortessanchez/Flo/blob/master/Screenshots/Part2-DocOutline.png">
</p>

7. In *ViewController*, add outlets for *Container View* and *Graph View*. Go to storyboard and connect the outlets with their views
```swift
@IBOutlet weak var containerView: UIView!
@IBOutlet weak var graphView: GraphView!
```

### Animation transition
1. Drag a **Tap Gesture Recognizer** to *Container View* in the storyboard
2. Add a property to *ViewController* to mark if the graph is being displayed
```swift
var isGraphViewShowing = false
```
3. Add tap method to do the transition. *UIView.transition(from:to:duration:options:completion:)* performs a horizontal flip transition
```swift
@IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
  if (isGraphViewShowing) {
    //hide Graph
    UIView.transition(from: graphView,
                      to: counterView,
                      duration: 1.0,
                      options: [.transitionFlipFromLeft, .showHideTransitionViews],
                      completion:nil)
  } else {
    //show Graph
    UIView.transition(from: counterView,
                      to: graphView,
                      duration: 1.0,
                      options: [.transitionFlipFromRight, .showHideTransitionViews],
                      completion: nil)
  }
  isGraphViewShowing = !isGraphViewShowing
}
```
4. Add this code to the end of *pushButtonPressed()*
```swift
if isGraphViewShowing {
  counterViewTap(nil)
}
```

### Draw a gradient
1. Make *GraphView.swift* a @IBDesignable class
2. Set up the start and end colors for the gradient
```swift
@IBInspectable var startColor: UIColor = .red
@IBInspectable var endColor: UIColor = .green
```
3. Next, inside *draw()* method obtain the current context. CG drawing functions need to know the context in which they will draw
```swift
let context = UIGraphicsGetCurrentContext()!
let colors = [startColor.cgColor, endColor.cgColor]
```
4. Create a color space for the context
```swift
let colorSpace = CGColorSpaceCreateDeviceRGB()
```
5. Add color stops. They describe where the colors in the gradient change over. Then create the actual gradient defining color space, colors and color stops
```swift
let colorLocations: [CGFloat] = [0.0, 1.0]
let gradient = CGGradient(colorsSpace: colorSpace,
                                     colors: colors as CFArray,
                                  locations: colorLocations)!
```
6. Draw the gradient
```swift
let startPoint = CGPoint.zero
      let endPoint = CGPoint(x: 0, y: bounds.height)
      context.drawLinearGradient(gradient,
                          start: startPoint,
                            end: endPoint,
                        options: [])
```
7. In the storyboard, select all the views (except the main view) and set the **Background Color** to **Clear Color**

### Clipping areas
1. Add these constants to the top of *GraphView*
```swift
private struct Constants {
  static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
  static let margin: CGFloat = 20.0
  static let topBorder: CGFloat = 60
  static let bottomBorder: CGFloat = 50
  static let colorAlpha: CGFloat = 0.3
  static let circleDiameter: CGFloat = 5.0
}
```
2. To create a clipping area that constrains the gradient, add this to the top of *draw()*
```swift
let path = UIBezierPath(roundedRect: rect,
                  byRoundingCorners: .allCorners,
                        cornerRadii: Constants.cornerRadiusSize)
path.addClip()
``` 

### Calculate graph points
1. At the top of *GraphView* add a property for weekly sample data
```swift
var graphPoints = [4, 2, 6, 4, 5, 8, 3]
```
2. Add this code at the top of *draw()*
```swift
let width = rect.width
let height = rect.height
``` 
3. Calculate x and y point at the end of *draw()*
```swift
let margin = Constants.margin
let graphWidth = width - margin * 2 - 4
let columnXPoint = { (column: Int) -> CGFloat in
  //Calculate the gap between points
  let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
  return CGFloat(column) * spacing + margin + 2
}

let topBorder = Constants.topBorder
let bottomBorder = Constants.bottomBorder
let graphHeight = height - topBorder - bottomBorder
let maxValue = graphPoints.max()!
let columnYPoint = { (graphPoint: Int) -> CGFloat in
  let y = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
  return graphHeight + topBorder - y // Flip the graph
}
```
4. Next, draw the line graph
```swift
UIColor.white.setFill()
UIColor.white.setStroke()
    
let graphPath = UIBezierPath()

graphPath.move(to: CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
    
for i in 1..<graphPoints.count {
  let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
  graphPath.addLine(to: nextPoint)
}
```

### Gradient graph
1. Set up the clipping path at the end of *draw()*
```swift
//context.saveGState()
    
let clippingPath = graphPath.copy() as! UIBezierPath
    
clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y:height))
clippingPath.addLine(to: CGPoint(x:columnXPoint(0), y:height))
clippingPath.close()
    
clippingPath.addClip()
    
let highestYPoint = columnYPoint(maxValue)
let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
//context.restoreGState()
```
2. Draw the original path
```swift
graphPath.lineWidth = 2.0
graphPath.stroke() 
```

### Draw data points
1. At the end of *draw()*, draw the circles on top of the graph stroke
```swift
for i in 0..<graphPoints.count {
  var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
  point.x -= Constants.circleDiameter / 2
  point.y -= Constants.circleDiameter / 2
      
  let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
  circle.fill()
}
```

### Context states
1. Uncomment [step 1](#gradient-graph) commented lines
2. At the end of *draw()*, draw three lines
```swift
let linePath = UIBezierPath()

linePath.move(to: CGPoint(x: margin, y: topBorder))
linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))

linePath.move(to: CGPoint(x: margin, y: graphHeight/2 + topBorder))
linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight/2 + topBorder))

linePath.move(to: CGPoint(x: margin, y:height - bottomBorder))
linePath.addLine(to: CGPoint(x:  width - margin, y: height - bottomBorder))
let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
color.setStroke()
    
linePath.lineWidth = 1.0
linePath.stroke()
``` 
3. Graph should look like this

<p align="left">
<img width="200" height="200" src="https://github.com/ccortessanchez/Flo/blob/master/Screenshots/Part2-GraphLines.png">
</p>

### Add labels to the graph
We are going to add the next labels to the graph
* *UILabel* with text "Water Drunk"
* *UILabel* with text "Average: "
* *UILabel* with text "2", next to the average label
* *UILabel* with text "99", right aligned next to the top of the graph
* *UILabel* with text "0", right aligned to the bottom of the graph
* A horizontal *StackView* with labels for each day of a week

<p align="left">
<img width="200" height="200" src="https://github.com/ccortessanchez/Flo/blob/master/Screenshots/Part2-GraphLabels.png">
</p>

1. Add the labels in storyboard and these outlets in *ViewController*
```swift
@IBOutlet weak var averageWaterDrunk: UILabel!
@IBOutlet weak var maxLabel: UILabel!
@IBOutlet weak var stackView: UIStackView!
```
2. In the storyboard, select Graph View and check **Hidden** so the graph view doesn't appear when the app launches
3. In *ViewController* add a method to set up the labels
```swift
func setupGraphDisplay() {

  let maxDayIndex = stackView.arrangedSubviews.count - 1
  
  graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter

  graphView.setNeedsDisplay()
  maxLabel.text = "\(graphView.graphPoints.max()!)"
    
  let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
  averageWaterDrunk.text = "\(average)"
    
  let today = Date()
  let calendar = Calendar.current
    
  let formatter = DateFormatter()
  formatter.setLocalizedDateFormatFromTemplate("EEEEE")
  
  for i in 0...maxDayIndex {
    if let date = calendar.date(byAdding: .day, value: -i, to: today),
      let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
      label.text = formatter.string(from: date)
    }
  }
} 
```
4. In *counterViewTap()*, call *setupGraphDisplay()* inside the else part of the conditional

### Result

<p align="left">
<img width="240" height="450" src="https://github.com/ccortessanchez/Flo/blob/master/Screenshots/Part2-GraphTransition.gif">
</p>



## Patterns and playgrounds

***
## License
Flo is available under the MIT license. See the [LICENSE](https://github.com/ccortessanchez/Flo/blob/master/LICENSE) file for more info.
