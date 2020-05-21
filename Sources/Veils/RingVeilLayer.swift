//
//  RingVeilLayer.swift
//  YourFilm_Example
//
//  Created by chunhuiLai on 2020/5/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

/**
 The internal subclass for CAShapeLayer.
 This is the class that handles all the drawing and animation.
 This class is not interacted with, instead
 properties are set in UICircularRing and those are delegated to here.

 */
class RingVeilLayer: CAShapeLayer {

    // MARK: Properties

    @NSManaged var value: CGFloat
    @NSManaged var minValue: CGFloat
    @NSManaged var maxValue: CGFloat

    /// the delegate for the value, is notified when value changes
    @NSManaged weak var ring: RingVeil!

    // MARK: Animation members

    var animationDuration: TimeInterval = 1.0
    var animationTimingFunction: CAMediaTimingFunctionName = .easeInEaseOut
    var animated = false

    /// the value label which draws the text for the current value
    lazy var valueLabel: UILabel = UILabel(frame: .zero)

    // MARK: Animatable properties

    /// whether or not animatable properties should be animated when changed
    var shouldAnimateProperties: Bool = false

    /// the animation duration for a animatable property animation
    var propertyAnimationDuration: TimeInterval = 0.0

    /// the properties which are animatable
    static let animatableProperties: [String] = ["innerRingWidth", "innerRingColor",
                                                         "outerRingWidth", "outerRingColor",
                                                         "fontColor", "innerRingSpacing"]

    // Returns whether or not a given property key is animatable
    static func isAnimatableProperty(_ key: String) -> Bool {
        return animatableProperties.firstIndex(of: key) != nil
    }

    // MARK: Init

    override init() {
        super.init()
    }

    override init(layer: Any) {
        // copy our properties to this layer which will be used for animation
        guard let layer = layer as? RingVeilLayer else { fatalError("unable to copy layer") }

        animationDuration = layer.animationDuration
        animationTimingFunction = layer.animationTimingFunction
        animated = layer.animated
        shouldAnimateProperties = layer.shouldAnimateProperties
        propertyAnimationDuration = layer.propertyAnimationDuration
        super.init(layer: layer)
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: Draw

    /**
     Overriden for custom drawing.
     Draws the outer ring, inner ring and value label.
     */
    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        UIGraphicsPushContext(ctx)
        // Draw the rings
        drawOuterRing()
        drawInnerRing(in: ctx)
        // Draw the label
        drawValueLabel()
        // Call the delegate and notifiy of updated value
        if let updatedValue = value(forKey: "value") as? CGFloat {
            ring.didUpdateValue(newValue: updatedValue)
        }
        UIGraphicsPopContext()

    }

    // MARK: Animation methods

    /**
     Watches for changes in the value property, and setNeedsDisplay accordingly
     */
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "value" || isAnimatableProperty(key) {
            return true
        } else {
            return super.needsDisplay(forKey: key)
        }
    }

    /**
     Creates animation when value property is changed
     */
    override func action(forKey event: String) -> CAAction? {
        if event == "value" && animated {
            let animation = CABasicAnimation(keyPath: "value")
            animation.fromValue = presentation()?.value(forKey: "value")
            animation.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
            animation.duration = animationDuration
            return animation
        } else if RingVeilLayer.isAnimatableProperty(event) && shouldAnimateProperties {
            let animation = CABasicAnimation(keyPath: event)
            animation.fromValue = presentation()?.value(forKey: event)
            animation.timingFunction = CAMediaTimingFunction(name: animationTimingFunction)
            animation.duration = propertyAnimationDuration
            return animation
        } else {
            return super.action(forKey: event)
        }
    }

    // MARK: Helpers

    /**
     Draws the outer ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawOuterRing() {
        guard ring.outerRingWidth > 0 else { return }
        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let offSet = calculateOuterRingOffset()
        let outerRadius = min(bounds.width, bounds.height) / 2 - offSet
        let start = ring.fullCircle ? 0 : ring.startAngle.rads
        let end = ring.fullCircle ? .pi * 2 : ring.endAngle.rads
        let outerPath = UIBezierPath(arcCenter: center,
                                     radius: outerRadius,
                                     startAngle: start,
                                     endAngle: end,
                                     clockwise: true)
        outerPath.lineWidth = ring.outerRingWidth
        outerPath.lineCapStyle = ring.outerCapStyle

        // Update path depending on style of the ring
        updateOuterRingPath(outerPath, radius: outerRadius)

        ring.outerRingColor.setStroke()
        outerPath.stroke()
    }

    /**
     Draws the inner ring for the view.
     Sets path properties according to how the user has decided to customize the view.
     */
    private func drawInnerRing(in ctx: CGContext) {
        guard ring.innerRingWidth > 0 else { return }

        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        let innerEndAngle = calculateInnerEndAngle()
        let radiusIn = calculateInnerRadius()

        // Start drawing
        let innerPath: UIBezierPath = UIBezierPath(arcCenter: center,
                                                   radius: radiusIn,
                                                   startAngle: ring.startAngle.rads,
                                                   endAngle: innerEndAngle.rads,
                                                   clockwise: ring.isClockwise)

        // Draw path
        ctx.setLineWidth(ring.innerRingWidth)
        ctx.setLineJoin(.round)
        ctx.setLineCap(ring.innerCapStyle)
        ctx.setStrokeColor(ring.innerRingColor.cgColor)
        ctx.addPath(innerPath.cgPath)
        ctx.drawPath(using: .stroke)

        if let gradientOptions = ring.gradientOptions {
            // Create gradient and draw it
            var cgColors: [CGColor] = [CGColor]()
            for color: UIColor in gradientOptions.colors {
                cgColors.append(color.cgColor)
            }

            guard let gradient: CGGradient = CGGradient(colorsSpace: nil,
                                                        colors: cgColors as CFArray,
                                                        locations: gradientOptions.colorLocations)
            else {
                fatalError("\nUnable to create gradient for progress ring.\n" +
                    "Check values of gradientColors and gradientLocations.\n")
            }

            ctx.saveGState()
            ctx.addPath(innerPath.cgPath)
            ctx.replacePathWithStrokedPath()
            ctx.clip()

            drawGradient(gradient,
                         start: gradientOptions.startPosition,
                         end: gradientOptions.endPosition,
                         in: ctx)

            ctx.restoreGState()
        }
    }

    /// Updates the outer ring path depending on the ring's style
    private func updateOuterRingPath(_ path: UIBezierPath, radius: CGFloat) {
  
        let center: CGPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let offSet = calculateOuterRingOffset()
        let outerRadius = min(bounds.width, bounds.height) / 2 - offSet
        let borderStartAngle = ring.outerCapStyle == .butt ? ring.startAngle - borderWidth : ring.startAngle
        let borderEndAngle = ring.outerCapStyle == .butt ? ring.endAngle + borderWidth : ring.endAngle
        let start = ring.fullCircle ? 0 : borderStartAngle.rads
        let end = ring.fullCircle ? .pi * 2 : borderEndAngle.rads
        let borderPath = UIBezierPath(arcCenter: center,
                                      radius: outerRadius,
                                      startAngle: start,
                                      endAngle: end,
                                      clockwise: true)
        UIColor.clear.setFill()
        borderPath.fill()
        borderPath.lineWidth = ring.outerRingWidth
        borderPath.lineCapStyle = ring.outerCapStyle
        ring.outerRingColor.setStroke()
      
        borderPath.stroke()
    }

    /// Returns the style dependent outer ring offset
    private func calculateOuterRingOffset() -> CGFloat {
        let borderWidth: CGFloat = 0

        return max(ring.outerRingWidth, ring.innerRingWidth) / 2
            + (borderWidth * 2)
    }

    /// Returns the end angle of the inner ring
    private func calculateInnerEndAngle() -> CGFloat {
        let innerEndAngle: CGFloat

        if ring.fullCircle {
            if !ring.isClockwise {
                innerEndAngle = ring.startAngle - ((value - minValue) / (maxValue - minValue) * 360.0)
            } else {
                innerEndAngle = (value - minValue) / (maxValue - minValue) * 360.0 + ring.startAngle
            }
        } else {
            // Calculate the center difference between the end and start angle
            let angleDiff: CGFloat = (ring.startAngle > ring.endAngle) ? (360.0 - ring.startAngle + ring.endAngle) : (ring.endAngle - ring.startAngle)
            // Calculate how much we should draw depending on the value set
            if !ring.isClockwise {
                innerEndAngle = ring.startAngle - ((value - minValue) / (maxValue - minValue) * angleDiff)
            } else {
                innerEndAngle = (value - minValue) / (maxValue - minValue) * angleDiff + ring.startAngle
            }
        }

        return innerEndAngle
    }

    /// Returns the raidus of the inner ring
    private func calculateInnerRadius() -> CGFloat {
        let borderWidth: CGFloat = 0
        
        let offSet = (max(ring.outerRingWidth, ring.innerRingWidth) / 2) + (borderWidth * 2)
        return (min(bounds.width, bounds.height) / 2) - offSet
    }

    /**
     Draws a gradient with a start and end position inside the provided context
     */
    private func drawGradient(_ gradient: CGGradient,
                              start: UICircularRingGradientPosition,
                              end: UICircularRingGradientPosition,
                              in context: CGContext) {

        context.drawLinearGradient(gradient,
                                   start: start.pointForPosition(in: bounds),
                                   end: end.pointForPosition(in: bounds),
                                   options: .drawsBeforeStartLocation)
    }

    /**
     Draws the value label for the view.
     Only drawn if shouldShowValueText = true
     */
    func drawValueLabel() {
        guard ring.shouldShowValueText else { return }

        // Draws the text field
        // Some basic label properties are set
        valueLabel.font = ring.font
        valueLabel.textAlignment = .center
        valueLabel.textColor = ring.fontColor
        let rate = value / maxValue * 100
        valueLabel.text = "\(String(format: "%.0f", rate))%"
        ring.willDisplayLabel(label: valueLabel)
        valueLabel.sizeToFit()

        // Deterime what should be the center for the label
        valueLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)

        valueLabel.drawText(in: bounds)
    }
}
