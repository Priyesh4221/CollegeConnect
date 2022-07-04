//
//  CircularAttendanceLoader.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 11/21/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class CircularAttendanceLoader: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0%"
    }
    
    
    //MARK: Public
    
    public var lineWidth:CGFloat = 10 {
        didSet{
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    public var labelSize: CGFloat = 30 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.textColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
            label.sizeToFit()
            configLabel()
        }
    }
    
    public var safePercent: Int = 100 {
        didSet{
            setForegroundLayerColorForSafePercent()
        }
    }
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        foregroundLayer.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            
        }
        
        var currentTime:Double = 0
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            if currentTime >= 2{
                timer.invalidate()
            } else {
                currentTime += 0.05
                let percent = currentTime/2 * 100
                self.label.text = "\(Int(progress * percent))%"
                self.setForegroundLayerColorForSafePercent()
                self.configLabel()
            }
        }
        timer.fire()
        
    }
    
    
    
    
    //MARK: Private
    private var label = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2.5 }
            else { return (self.frame.height - lineWidth)/2.5 }
        }
        
    }
    public var publicradius : CGFloat = 100
    public var actualradius : CGFloat
    {
        get {
            return self.publicradius
        }
        
        set {
            self.publicradius = self.publicradius - (lineWidth / 2)
            
        }
        
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        self.backgroundLayer.lineWidth = lineWidth - (lineWidth * 20/100)
        self.backgroundLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer(){
        
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = kCALineCapRound
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = #colorLiteral(red: 0.01568627451, green: 0.2235294118, blue: 0.1529411765, alpha: 1)
        foregroundLayer.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = pathCenter
        label.textColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
        return label
    }
    
    private func configLabel(){
        label.sizeToFit()
        label.center = pathCenter
    }
    
    private func setForegroundLayerColorForSafePercent(){

            self.foregroundLayer.strokeColor = #colorLiteral(red: 0.01568627451, green: 0.2235294118, blue: 0.1529411765, alpha: 1)
        
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(label)
    }
    
    
    
    //Layout Sublayers
    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = "\(tempText)%"
            layoutDone = true
        }
    }


}
