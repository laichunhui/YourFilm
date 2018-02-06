//
//  Configs.swift
//  YourFilm
//
//  Created by Chunhui on 2018/2/6.
//  Copyright © 2018年 chunhuiLai. All rights reserved.
//

import UIKit

extension Array {
    
    ///Element at the given index if it exists.
    func sy_Element(at index: Int) -> Element? {
        
        guard startIndex..<endIndex ~= index else { return nil }
        return self[index]
    }
}

extension String {
    func sy_size(titleFont font: UIFont,
                 maxWidth width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        
        let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedStringKey.font: font],
                                     context: nil)
        return rect.size
    }
}

extension UIColor {
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(syHexValue: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((syHexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((syHexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(syHexValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(syHexValue: UInt) {
        self.init(
            red: CGFloat((syHexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((syHexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(syHexValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

public protocol SYThen {}

public extension SYThen where Self: Any {
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then( block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
}

public extension SYThen where Self: AnyObject {
    /// Makes it available to set properties with closures just after initializing.
    ///
    ///     let label = UILabel().then {
    ///         $0.textAlignment = .Center
    ///         $0.textColor = UIColor.blackColor()
    ///         $0.text = "Hello, World!"
    ///     }
    public func then( block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

extension NSObject: SYThen {}

