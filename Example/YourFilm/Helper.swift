//
//  Helper.swift
//  YourFilm
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit

extension UIView {  // Reuse
    
    class var name: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    class var reuseIdentifier: String {
        return name//String(format: "%@_identifier", self.nameOfClass)
    }
    
    class func NibInstance() -> UINib {
        return UINib(nibName: self.name, bundle:nil)
    }
    
    class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T {
        let v: T? = fromNib(nibNameOrNil)
        return v!
    }
    
    class func fromNib<T : UIView>(_ nibNameOrNil: String? = nil) -> T? {
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = "\(T.self)".components(separatedBy: ".").last!
        }
        
        let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
        for v in nibViews! {
            if let tog = v as? T {
                view = tog
            }
        }
        return view
    }
}
