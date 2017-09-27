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
  * [Screenshot](#screenshot)
* [Gradients and contexts](#gradients-and-contexts)
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

### Screenshot
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


## Patterns and playgrounds

***
## License
Flo is available under the MIT license. See the [LICENSE](https://github.com/ccortessanchez/Flo/blob/master/LICENSE) file for more info.
