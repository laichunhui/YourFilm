//
//  RGBColorSelector.swift
//  YourFilm_Example
//
//  Created by mac on 2018/8/24.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit


class RGBColorSelector: UIView {
    
    //red
    
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var redValueField: UITextField!
    
    //green
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBOutlet weak var greenValueField: UITextField!
    
    //blue
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var blueValueField: UITextField!
    
    //opacity
    @IBOutlet weak var opacitySlider: UISlider!
    
    @IBOutlet weak var opacityValueField: UITextField!
    
    
    //model view
    @IBOutlet weak var modelView: UIView!
    
    
    var color: UIColor {
        let red = CGFloat(redSlider.value / 255.0)
        let green = CGFloat(greenSlider.value / 255.0)
        let blue = CGFloat(blueSlider.value / 255.0)
        
        let alpha = CGFloat(opacitySlider.value)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func display() {
        modelView.backgroundColor = self.color
    }
    
    @IBAction func redSliderValueDidChanged(_ sender: UISlider) {
        redValueField.text = "\(Int(sender.value))"
        display()
    }
    @IBAction func redValueChanged(_ sender: UITextField) {
        if let value = Float(sender.text ?? "") {
            redSlider.value = value
        }
    }
    
    @IBAction func greenSliderValueDidChanged(_ sender: UISlider) {
        greenValueField.text = "\(Int(sender.value))"
        display()
    }
    @IBAction func greenValueChanged(_ sender: UITextField) {
        if let value = Float(sender.text ?? "") {
            greenSlider.value = value
        }
    }
    
    @IBAction func blueSliderValueDidChanged(_ sender: UISlider) {
        blueValueField.text = "\(Int(sender.value))"
        display()
    }
    @IBAction func blueValueChanged(_ sender: UITextField) {
        if let value = Float(sender.text ?? "") {
            blueSlider.value = value
        }
    }
    
    @IBAction func opacitySliderValueDidChanged(_ sender: UISlider) {
        opacityValueField.text = String(format: "%0.2f", sender.value) 
        display()
    }
    @IBAction func opacityValueChanged(_ sender: UITextField) {
        if let value = Float(sender.text ?? "") {
            opacitySlider.value = value
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        display()
    }
    
    
    static var nibDefault: RGBColorSelector {
        return RGBColorSelector.fromNib(RGBColorSelector.name)
    }
    
}
