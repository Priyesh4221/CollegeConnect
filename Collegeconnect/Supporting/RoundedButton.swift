//
//  RoundedButton.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/1/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable var cornradius : CGFloat = 0
        {
        didSet
        {
            self.layer.cornerRadius = self.frame.size.height/2
//            self.layer.masksToBounds = cornradius > 0
        }
        
    }
    
    @IBInspectable var borderwidth : CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderwidth
        }
    }
    @IBInspectable var bordercolor : UIColor? {
        didSet {
            self.layer.borderColor = bordercolor?.cgColor
            
        }
    }
    @IBInspectable var bgcolor : UIColor? {
        didSet {
            self.layer.backgroundColor = bgcolor?.cgColor
        }
    }
    
    @IBInspectable var shadowcolor : UIColor? {
        didSet {
            self.layer.shadowColor = shadowcolor?.cgColor
        }
    }
    
    @IBInspectable var shadowopacity : Float = 0 {
        didSet {
            self.layer.shadowOpacity = shadowopacity
        }
    }
    
    @IBInspectable var shadowoffsetwidth : CGFloat = 0 {
        didSet {
            self.layer.shadowOffset.width = shadowoffsetwidth
        }
    }
    @IBInspectable var shadowoffsetheight : CGFloat = 0 {
        didSet {
            self.layer.shadowOffset.height = shadowoffsetheight
        }
    }
    
    @IBInspectable var shadowradius : CGFloat = 0 {
        didSet {
            self.layer.shadowRadius = shadowradius
        }
    }


}
