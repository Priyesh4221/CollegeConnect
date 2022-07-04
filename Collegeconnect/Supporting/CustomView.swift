//
//  CustomView.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/21/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
@IBDesignable
class CustomView: UIView {
    
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: CustomView.self), owner: self, options: nil)
        
    }

    @IBInspectable var cornradius : CGFloat = 0
        {
        didSet
        {
            self.layer.cornerRadius = cornradius
            self.layer.masksToBounds = cornradius > 0
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



@IBDesignable
class CustomTextField: UITextField {
    
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
       return bounds.insetBy(dx: 10, dy: 12)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
       return bounds.insetBy(dx: 10, dy: 12)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 12)
    }
    
    @IBInspectable var cornradius : CGFloat = 0
        {
        didSet
        {
            self.layer.cornerRadius = cornradius
            self.layer.masksToBounds = cornradius > 0
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





class ShadowRoundedImageView: UIView {
    @IBInspectable var image: UIImage? = nil {
        didSet {
            imageLayer.contents = image?.cgImage
            shadowLayer.shadowPath = (image == nil) ? nil : shapeAsPath }}
    
    var imageLayer: CALayer = CALayer()
    var shadowLayer: CALayer = CALayer()
    
    var shape: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius:50) }
    
    var shapeAsPath: CGPath {
        return shape.cgPath }
    
    var shapeAsMask: CAShapeLayer {
        let s = CAShapeLayer()
        s.path = shapeAsPath
        return s }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
        backgroundColor = .clear
        
        self.layer.addSublayer(shadowLayer)
        self.layer.addSublayer(imageLayer) // (in that order)
        
        imageLayer.frame = bounds

        
        imageLayer.mask = shapeAsMask
        shadowLayer.shadowPath = (image == nil) ? nil : shapeAsPath
        shadowLayer.shadowOpacity = 0.80 // etc ...
    }
}
