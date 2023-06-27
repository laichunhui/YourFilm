//
//  RingVeil.swift
//  YourFilm_Example
//
//  Created by chunhuiLai on 2020/5/19.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

/**

 # RingVeil

 You should not instantiate this class, instead use one of the concrete classes provided
 or subclass and make your own.

 This is the UIView subclass that creates and handles everything
 to do with the circular ring.

 This class has a custom CAShapeLayer (`RingVeilLayer`) which
 handels the drawing and animating of the view
 
 ## Reference
  https://github.com/luispadron/UICircularProgressRing
 */

@IBDesignable open class RingVeil: UIView {

    // MARK: Circle Properties

    /**
     Whether or not the progress ring should be a full circle.

     What this means is that the outer ring will always go from 0 - 360 degrees and
     the inner ring will be calculated accordingly depending on current value.

     ## Important ##
     Default = true

     When this property is true any value set for `endAngle` will be ignored.
     */
    @IBInspectable open var fullCircle: Bool = true {
        didSet { ringLayer.setNeedsDisplay() }
    }

    // MARK: View Style

    /**
     The options for a gradient ring.

     If this is non-`nil` then a gradient style will be applied.

     ## Important ##
    Default = `nil`
    */
    open var gradientOptions: UICircularRingGradientOptions? = nil {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     A toggle for showing or hiding the value label.
     If false the current value will not be shown.

     ## Important ##
     Default = true

     ## Author
     Luis Padron
     */
    @IBInspectable public var shouldShowValueText: Bool = true {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The start angle for the entire progress ring view.

     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top

     ## Important ##
     Default = -90 (degrees)

     Values should be in degrees (they're converted to radians internally)

     ## Author
     Luis Padron
     */
    @IBInspectable open var startAngle: CGFloat = -90 {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The end angle for the entire progress ring

     Please note that Cocoa Touch uses a clockwise rotating unit circle.
     I.e: 90 degrees is at the bottom and 270 degrees is at the top

     ## Important ##
     Default = 270 (degrees)

     Values should be in degrees (they're converted to radians internally)

     ## Author
     Luis Padron
     */
    @IBInspectable open var endAngle: CGFloat = 270 {
        didSet { ringLayer.setNeedsDisplay() }
    }

    // MARK: Outer Ring properties

    /**
     The width of the outer ring for the progres bar

     ## Important ##
     Default = 6.0

     ## Author
     Luis Padron
     */
    @IBInspectable open var outerRingWidth: CGFloat = 5.0 {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The color for the outer ring

     ## Important ##
     Default = UIColor.gray

     ## Author
     Luis Padron
     */
    @IBInspectable open var outerRingColor: UIColor = UIColor.gray {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The style for the tip/cap of the outer ring

     Type: `CGLineCap`

     ## Important ##
     Default = CGLineCap.butt

     This is only noticible when ring is not a full circle.

     ## Author
     Luis Padron
     */
    open var outerCapStyle: CGLineCap = .butt {
        didSet { ringLayer.setNeedsDisplay() }
    }

    // MARK: Inner Ring properties

    /**
     The width of the inner ring for the progres bar

     ## Important ##
     Default = 5.0

     ## Author
     Luis Padron
     */
    @IBInspectable open var innerRingWidth: CGFloat = 5.0 {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The color of the inner ring for the progres bar

     ## Important ##
     Default = UIColor.blue

     ## Author
     Luis Padron
     */
    @IBInspectable open var innerRingColor: UIColor = UIColor.blue {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The spacing between the outer ring and inner ring

     ## Important ##
     This only applies when using `ringStyle` = `.inside`

     Default = 1

     ## Author
     Luis Padron
     */
    @IBInspectable open var innerRingSpacing: CGFloat = 1 {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The style for the tip/cap of the inner ring

     Type: `CGLineCap`

     ## Important ##
     Default = CGLineCap.round

     ## Author
     Luis Padron
     */
    open var innerCapStyle: CGLineCap = .round {
        didSet { ringLayer.setNeedsDisplay() }
    }

    // MARK: Label

    /**
     The text color for the value label field

     ## Important ##
     Default = UIColor.black


     ## Author
     Luis Padron
     */
    @IBInspectable open var fontColor: UIColor = UIColor.black {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     The font to be used for the progress indicator.
     All font attributes are specified here except for font color, which is done
     using `fontColor`.


     ## Important ##
     Default = UIFont.systemFont(ofSize: 18)


     ## Author
     Luis Padron
     */
    @IBInspectable open var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     This returns whether or not the ring is currently animating

     ## Important ##
     Get only property

     ## Author
     Luis Padron
     */
    open var isAnimating: Bool {
        return ringLayer.animation(forKey: .value) != nil
    }

    /**
     The direction the circle is drawn in
     Example: true -> clockwise

     ## Important ##
     Default = true (draw the circle clockwise)

     ## Author
     Pete Walker
     */
    @IBInspectable open var isClockwise: Bool = true {
        didSet { ringLayer.setNeedsDisplay() }
    }

    /**
     Typealias for animateProperties(duration:animations:completion:) fucntion completion
     */
    public typealias PropertyAnimationCompletion = (() -> Void)

    // MARK: Private / internal

    /**
     Set the ring layer to the default layer, cated as custom layer
     */
    var ringLayer: RingVeilLayer {
        // swiftlint:disable:next force_cast
        return layer as! RingVeilLayer
    }

    /// This variable stores how long remains on the timer when it's paused
    private var pausedTimeRemaining: TimeInterval = 0

    /// Used to determine when the animation was paused
    private var animationPauseTime: CFTimeInterval?

    /// This stores the animation when the timer is paused. We use this variable to continue the animation where it left off.
    /// See https://stackoverflow.com/questions/7568567/restoring-animation-where-it-left-off-when-app-resumes-from-background
    var snapshottedAnimation: CAAnimation?

    /// The completion timer, also indicates whether or not the view is animating
    var animationCompletionTimer: Timer?

    typealias AnimationCompletion = () -> Void

    // MARK: Methods

    /**
     Overrides the default layer with the custom UICircularRingLayer class
     */
    override open class var layerClass: AnyClass {
        return RingVeilLayer.self
    }

    /**
     Overriden public init to initialize the layer and view
     */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        // Call the internal initializer
        initialize()
    }

    /**
     Overriden public init to initialize the layer and view
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Call the internal initializer
        initialize()
    }

    /**
     This method initializes the custom CALayer to the default values
     */
    func initialize() {
        // This view will become the value delegate of the layer, which will call the updateValue method when needed
        ringLayer.ring = self

        // Helps with pixelation and blurriness on retina devices
        ringLayer.contentsScale = UIScreen.main.scale
        ringLayer.shouldRasterize = true
        ringLayer.rasterizationScale = UIScreen.main.scale * 2
        ringLayer.masksToBounds = false

        backgroundColor = UIColor.clear
        ringLayer.backgroundColor = UIColor.clear.cgColor

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(restoreAnimation),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(snapshotAnimation),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
    }

    /**
     Overriden because of custom layer drawing in UICircularRingLayer
     */
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    // MARK: Internal API

    /**
     These methods are called from the layer class in order to notify
     this class about changes to the value and label display.

     In this base class they do nothing.
     */

    func didUpdateValue(newValue: CGFloat) { }

    func willDisplayLabel(label: UILabel) { }

    /**
     These functions are here to allow reuse between subclasses.
     They handle starting, pausing and resetting an animation of the ring.
    */

    func startAnimation(duration: TimeInterval, completion: @escaping AnimationCompletion) {
        if isAnimating {
            animationPauseTime = nil
        }

        ringLayer.timeOffset = 0
        ringLayer.beginTime = 0
        ringLayer.speed = 1
        ringLayer.animated = duration > 0
        ringLayer.animationDuration = duration

        // Check if a completion timer is still active and if so stop it
        animationCompletionTimer?.invalidate()
        animationCompletionTimer = Timer.scheduledTimer(timeInterval: duration,
                                                        target: self,
                                                        selector: #selector(self.animationDidComplete),
                                                        userInfo: completion,
                                                        repeats: false)
    }

    func pauseAnimation() {
        guard isAnimating else {
            #if DEBUG
            print("""
                    UICircularProgressRing: Progress was paused without having been started.
                    This has no effect but may indicate that you're unnecessarily calling this method.
                    """)
            #endif
            return
        }

        snapshotAnimation()

        let pauseTime = ringLayer.convertTime(CACurrentMediaTime(), from: nil)
        animationPauseTime = pauseTime

        ringLayer.speed = 0.0
        ringLayer.timeOffset = pauseTime

        if let fireTime = animationCompletionTimer?.fireDate {
            pausedTimeRemaining = fireTime.timeIntervalSince(Date())
        } else {
            pausedTimeRemaining = 0
        }

        animationCompletionTimer?.invalidate()
        animationCompletionTimer = nil
    }

    func continueAnimation(completion: @escaping AnimationCompletion) {
        guard let pauseTime = animationPauseTime else {
            #if DEBUG
            print("""
                    UICircularRing: Progress was continued without having been paused.
                    This has no effect but may indicate that you're unnecessarily calling this method.
                    """)
            #endif
            return
        }

        restoreAnimation()

        ringLayer.speed = 1.0
        ringLayer.timeOffset = 0.0
        ringLayer.beginTime = 0.0

        let timeSincePause = ringLayer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime

        ringLayer.beginTime = timeSincePause

        animationCompletionTimer?.invalidate()
        animationCompletionTimer = Timer.scheduledTimer(timeInterval: pausedTimeRemaining,
                                               target: self,
                                               selector: #selector(animationDidComplete),
                                               userInfo: completion,
                                               repeats: false)

        animationPauseTime = nil
    }

    func resetAnimation() {
        ringLayer.animated = false
        ringLayer.removeAnimation(forKey: .value)
        snapshottedAnimation = nil

        // Stop the timer and thus make the completion method not get fired
        animationCompletionTimer?.invalidate()
        animationCompletionTimer = nil
        animationPauseTime = nil

    }

    // MARK: API

    /**
     This function allows animation of the animatable properties of the `UICircularRing`.
     These properties include `innerRingColor, innerRingWidth, outerRingColor, outerRingWidth, innerRingSpacing, fontColor`.

     Simply call this function and inside of the animation block change the animatable properties as you would in any `UView`
     animation block.

     The completion block is called when all animations finish.
     */
    open func animateProperties(duration: TimeInterval, animations: () -> Void) {
        animateProperties(duration: duration, animations: animations, completion: nil)
    }

    /**
     This function allows animation of the animatable properties of the `UICircularRing`.
     These properties include `innerRingColor, innerRingWidth, outerRingColor, outerRingWidth, innerRingSpacing, fontColor`.

     Simply call this function and inside of the animation block change the animatable properties as you would in any `UView`
     animation block.

     The completion block is called when all animations finish.
     */
    open func animateProperties(duration: TimeInterval, animations: () -> Void,
                                completion: PropertyAnimationCompletion? = nil) {
        ringLayer.shouldAnimateProperties = true
        ringLayer.propertyAnimationDuration = duration
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            // Reset and call completion
            self.ringLayer.shouldAnimateProperties = false
            self.ringLayer.propertyAnimationDuration = 0.0
            completion?()
        }
        // Commit and perform animations
        animations()
        CATransaction.commit()
    }
}

// MARK: Helpers

extension RingVeil {
    /**
     This method is called when the application goes into the background or when the
     ProgressRing is paused using the pauseProgress method.
     This is necessary for the animation to properly pick up where it left off.
     Triggered by UIApplicationWillResignActive.

     ## Author
     Nicolai Cornelis
     */
    @objc func snapshotAnimation() {
        guard let animation = ringLayer.animation(forKey: .value) else { return }
        snapshottedAnimation = animation
    }

    /**
     This method is called when the application comes back into the foreground or
     when the ProgressRing is resumed using the continueProgress method.
     This is necessary for the animation to properly pick up where it left off.
     Triggered by UIApplicationWillEnterForeground.

     ## Author
     Nicolai Cornelis
     */
    @objc func restoreAnimation() {
        guard let animation = snapshottedAnimation else { return }
        ringLayer.add(animation, forKey: AnimationKeys.value.rawValue)
    }

    /// Called when the animation timer is complete
    @objc func animationDidComplete(withTimer timer: Timer) {
        (timer.userInfo as? AnimationCompletion)?()
    }
}

extension RingVeil {
    /// Helper enum for animation key
    enum AnimationKeys: String {
        case value
    }
}




// MARK: UICircularRingGradientPosition

/**

 UICircularRingGradientPosition

 This is an enumeration which is used to determine the position for a
 gradient. Used inside the `UICircularRingLayer` to allow customization
 for the gradient.
 */
public enum UICircularRingGradientPosition {
    /// Gradient positioned at the top
    case top
    /// Gradient positioned at the bottom
    case bottom
    /// Gradient positioned to the left
    case left
    /// Gradient positioned to the right
    case right
    /// Gradient positioned in the top left corner
    case topLeft
    /// Gradient positioned in the top right corner
    case topRight
    /// Gradient positioned in the bottom left corner
    case bottomLeft
    /// Gradient positioned in the bottom right corner
    case bottomRight

    /**
     Returns a `CGPoint` in the coordinates space of the passed in `CGRect`
     for the specified position of the gradient.
     */
    func pointForPosition(in rect: CGRect) -> CGPoint {
        switch self {
        case .top:
            return CGPoint(x: rect.midX, y: rect.minY)
        case .bottom:
            return CGPoint(x: rect.midX, y: rect.maxY)
        case .left:
            return CGPoint(x: rect.minX, y: rect.midY)
        case .right:
            return CGPoint(x: rect.maxX, y: rect.midY)
        case .topLeft:
            return CGPoint(x: rect.minX, y: rect.minY)
        case .topRight:
            return CGPoint(x: rect.maxX, y: rect.minY)
        case .bottomLeft:
            return CGPoint(x: rect.minX, y: rect.maxY)
        case .bottomRight:
            return CGPoint(x: rect.maxX, y: rect.maxY)
        }
    }
}

// MARK: UICircularRingGradientOptions

/**
 UICircularRingGradientOptions

 Struct for defining the options for the UICircularRingStyle.gradient case.

 ## Important ##
 Make sure the number of `colors` is equal to the number of `colorLocations`
 */
public struct UICircularRingGradientOptions {

    /// a default styling option for the gradient style
    public static let `default` = UICircularRingGradientOptions(startPosition: .top,
                                                            endPosition: .topLeft,
                                                            colors: [.red, .blue],
                                                            colorLocations: [0, 1])

    /// the start location for the gradient
    public let startPosition: UICircularRingGradientPosition

    /// the end location for the gradient
    public let endPosition: UICircularRingGradientPosition

    /// the colors to use in the gradient, the count of this list must match the count of `colorLocations`
    public let colors: [UIColor]

    /// the locations of where to place the colors, valid numbers are from 0.0 - 1.0
    public let colorLocations: [CGFloat]

    /// create a new UICircularRingGradientOptions
    public init(startPosition: UICircularRingGradientPosition,
                endPosition: UICircularRingGradientPosition,
                colors: [UIColor],
                colorLocations: [CGFloat]) {
        self.startPosition = startPosition
        self.endPosition = endPosition
        self.colors = colors
        self.colorLocations = colorLocations
    }
}
