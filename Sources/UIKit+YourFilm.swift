//
//  UIKit+YourFilm.swift
//  FBSnapshotTestCase
//
//  Created by Chunhui on 2018/2/7.
//

import UIKit

public extension IntegerLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
}

public extension FloatLiteralType {
    var f: CGFloat {
        return CGFloat(self)
    }
}


/**
 A private extension to CGFloat in order to provide simple
 conversion from degrees to radians, used when drawing the rings.
 */
extension CGFloat {
    var rads: CGFloat { return self * CGFloat.pi / 180 }
}

/// adds simple conversion to TimeInterval
extension CGFloat {
    var interval: TimeInterval { return TimeInterval(self) }
}


extension Array {
    
    ///Element at the given index if it exists.
    func yf_Element(at index: Int) -> Element? {
        
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}

extension String {
    func yf_size(titleFont font: UIFont,
                 maxWidth width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        return rect.size
    }
}



extension Int {
    public var color: UIColor {
        let red = CGFloat(self as Int >> 16 & 0xff) / 255
        let green = CGFloat(self >> 8 & 0xff) / 255
        let blue  = CGFloat(self & 0xff) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}

extension UIColor {
    public func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}


/// Helper extension to allow removing layer animation based on AnimationKeys enum
extension CALayer {
    func removeAnimation(forKey key: RingVeil.AnimationKeys) {
        removeAnimation(forKey: key.rawValue)
    }

    func animation(forKey key: RingVeil.AnimationKeys) -> CAAnimation? {
        return animation(forKey: key.rawValue)
    }

    func value(forKey key: RingVeil.AnimationKeys) -> Any? {
        return value(forKey: key.rawValue)
    }
}
