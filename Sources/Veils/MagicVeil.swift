//
//  MagicVeil.swift
//  YourFilm
//
//  Created by chunhuiLai on 2017/3/31.
//  Copyright © 2017年 qjzh. All rights reserved.
//

import UIKit

@IBDesignable
public class MagicVeil: UIView {
    /**
     Current progress value. (0.0 - 1.0)
     */
    @IBInspectable open var progress: Double = 0.0 {
        didSet {
            let clipProgress = max( min(progress, Double(1.0)), Double(0.0) )
           
            update(progress: clipProgress)
            
            progressChanged?(clipProgress, self)
            delegate?.progressChanged(progress: clipProgress, on: self)
        }
    }
    
    /**
     Main progress line width.
     */
    @IBInspectable open var lineWidth: CGFloat = 8.0 {
        didSet {
            progressLayer.lineWidth = lineWidth
        }
    }
    
    /**
     Guide progress line width.
     */
    @IBInspectable open var guideLineWidth: CGFloat = 8.0 {
        didSet {
            guideLayer.lineWidth = CGFloat(guideLineWidth)
        }
    }
    
    /**
     Progress guide bar color.
     */
    @IBInspectable open var guideColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2) {
        didSet {
            guideLayer.strokeColor = guideColor.cgColor
        }
    }
    
    /**
     Switch of progress guide view. If you set to `true`, progress guide view is enabled.
     */
    @IBInspectable open var shouldShowGuide: Bool = false {
        didSet {
          
            guideLayer.isHidden = !shouldShowGuide
            guideLayer.backgroundColor = shouldShowGuide ? guideColor.cgColor : UIColor.clear.cgColor
        }
    }
    
    /**
     Progress bar path. You can create various type of progress bar.
     */
    open var path: UIBezierPath? {
        didSet {
            progressLayer.path = path?.cgPath
            guideLayer.path = path?.cgPath
        }
    }
    
    /**
     Progress bar colors. You can set many colors in `colors` property, and it makes gradation color in `colors`.
     */
    open var colors: [UIColor] = [UIColor(syHexValue: 0x4BAEB), UIColor(syHexValue: 0x54BA24)] {
        didSet {
            update(colors: colors)
        }
    }
    
    /**
     Progress start angle.
     */
    open var startAngle: CGFloat = 0.0 {
        didSet {
            progressLayer.startAngle = startAngle
            guideLayer.startAngle = startAngle
        }
    }
    
    /**
     Progress end angle.
     */
    open var endAngle: CGFloat = 0.0 {
        didSet {
            progressLayer.endAngle = endAngle
            guideLayer.endAngle = endAngle
        }
    }
    
    open var delegate: FilmProgressDelegate?
    
    /**
     Typealias of progressChangedClosure.
     */
    public typealias progressChangedHandler = (_ progress: Double, _ veil: MagicVeil) -> Void
    
    /**
     This closure is called when set value to `progress` property.
     */
    fileprivate var progressChanged: progressChangedHandler?
    
    fileprivate lazy var progressLayer: CircularShapeLayer = {
        let layer = CircularShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.lineWidth
        //layer.cornerRadius = self.radius
        
        let halfWidth: CGFloat = layer.frame.width / 2.0
        layer.path = UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth - 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
        
        layer.strokeEnd = 0
        layer.strokeColor = self.tintColor.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
       
        return layer
    }()
    
    /**
     Gradient mask layer of `progressView`.
     */
    fileprivate lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer(layer: self.layer)
        gradientLayer.frame = self.progressLayer.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.mask = self.progressLayer
        gradientLayer.colors = self.colors
        
        return gradientLayer
    }()
    
    /**
     Mask layer of `progressGuideView`.
     */
    fileprivate lazy var guideLayer: CircularShapeLayer = {
        
        let layer = CircularShapeLayer()
        layer.frame = self.bounds
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = self.lineWidth
        layer.backgroundColor = UIColor.clear.cgColor
    
//        layer.strokeColor = self.tintColor.cgColor
//        layer.strokeEnd = 1.0
        return layer
    }()
    
    private var radius: CGFloat {
        return lineWidth >= guideLineWidth ? lineWidth : guideLineWidth
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        setNeedsLayout()
//        layoutIfNeeded()
        
        update(colors: colors)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    
      //  layer.addSublayer(guideLayer)
        
//        setNeedsLayout()
//        layoutIfNeeded()
        
        update(colors: colors)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if path == nil {
            let halfWidth: CGFloat = frame.width / 2.0
            guideLayer.path = UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth - 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
            progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth - 10, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
            
//            progressLayer.display()
//            guideLayer.display()
        }
        
        layer.addSublayer(gradientLayer)
        
        layer.addSublayer(guideLayer)
        layer.insertSublayer(progressLayer, above: guideLayer)
 
        
//        progressLayer.display()
    }
    
    /**
     Create `KYCircularProgress` with progress guide.
     
     - parameter frame: `KYCircularProgress` frame.
     - parameter showProgressGuide: If you set to `true`, progress guide view is enabled.
     */
    public init(frame: CGRect, showGuide: Bool) {
        super.init(frame: frame)
        self.shouldShowGuide = showGuide
        guideLayer.backgroundColor = showGuide ? guideColor.cgColor : UIColor.clear.cgColor
    }
    
    /**
     This closure is called when set value to `progress` property.
     
     - parameter completion: progress changed closure.
     */
    open func progressChanged(completion: @escaping progressChangedHandler) {
        progressChanged = completion
    }
    
    public func set(progress: Double, duration: Double) {
        let clipProgress = max( min(progress, Double(1.0)), Double(0.0) )
      //  progressView.update(progress: clipProgress, duration: duration)
        progressLayer.strokeEnd = CGFloat(progress)
        
        progressChanged?(clipProgress, self)
        delegate?.progressChanged(progress: clipProgress, on: self)
    }
    
    fileprivate func update(colors: [UIColor]) {
        gradientLayer.colors = colors.map {$0.cgColor}
        if colors.count == 1 {
            gradientLayer.colors?.append(colors.first!.cgColor)
        }
    }
    
    fileprivate func display() {
        
    }
    
    fileprivate func update(progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        progressLayer.strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }

    fileprivate func update(progress: Double, duration: Double) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = progress
        progressLayer.add(animation, forKey: "animateStrokeEnd")
        CATransaction.commit()
        progressLayer.strokeEnd = CGFloat(progress)
    }
    
}

// MARK: - KYCircularShapeView
class CircularShapeLayer: CAShapeLayer {
    var startAngle: CGFloat = 0.0
    var endAngle: CGFloat = 0.0
    var radius: CGFloat = 0.0
    
    override init() {
        super.init()
        update(progress: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        if startAngle == endAngle {
            endAngle = startAngle + CGFloat.pi * 2
        }
        
        self.path = self.path ?? layoutPath().cgPath
    }
    
    private func layoutPath() -> UIBezierPath {
        let halfWidth = CGFloat(frame.width / 2.0)
        return UIBezierPath(arcCenter: CGPoint(x: halfWidth, y: halfWidth), radius: (frame.width - CGFloat(radius)) / 2, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
    }
    
    fileprivate func update(progress: Double) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        strokeEnd = CGFloat(progress)
        CATransaction.commit()
    }
    
    fileprivate func update(progress: Double, duration: Double) {
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fromValue = strokeEnd
        animation.toValue = progress
        add(animation, forKey: "animateStrokeEnd")
        CATransaction.commit()
        strokeEnd = CGFloat(progress)
    }
}

