[![Platform](http://img.shields.io/badge/platform-ios-blue.svg)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-yellow.svg)](https://developer.apple.com/swift)
[![Version](http://img.shields.io/badge/version-4.0-orange.svg)](#)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg)](http://mit-license.org)

# Flo

# Table of contents
* [Description](#description)
* [Requirements](#requirements)
* [Built with](#built-with)
* [Usage](#usage)
  * [Custom drawing on views](#custom-drawing-on-views)
    * [Example: Plus button](#plus-button-example)
  * [Custom storyboard properties](#custom-storyboard-properties)
    * [Example: Inspectable variables](#inspectable-variable-examples)
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
## Usage
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

***

## License
Flo is available under the MIT license. See the [LICENSE](https://github.com/ccortessanchez/Flo/blob/master/LICENSE) file for more info.
