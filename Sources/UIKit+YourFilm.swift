//
//  UIKit+YourFilm.swift
//  FBSnapshotTestCase
//
//  Created by Chunhui on 2018/2/7.
//

import UIKit

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
                                     attributes: [NSAttributedStringKey.font: font],
                                     context: nil)
        return rect.size
    }
}

extension UIColor {
    //用数值初始化颜色，便于生成设计图上标明的十六进制颜色
    convenience init(yfHexValue: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((yfHexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((yfHexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(yfHexValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    convenience init(yfHexValue: UInt) {
        self.init(
            red: CGFloat((yfHexValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((yfHexValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(yfHexValue & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}