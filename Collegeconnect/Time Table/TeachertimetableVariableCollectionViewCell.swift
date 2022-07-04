//
//  TeachertimetableVariableCollectionViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/27/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class TeachertimetableVariableCollectionViewCell: UICollectionViewCell {
    
    var tappedclass : timetablevariable?
    
    @IBOutlet weak var lab: UILabel!
    
    func updatecell(x:String,y:Bool)
    {
    lab.font = lab.font?.withSize(Dataservices.ds.midfontsize)
        self.layer.cornerRadius = self.frame.size.height / 2
        self.backgroundColor = UIColor.clear
        
        self.lab.text = x
        if y == true {
            self.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
            
        }
    }
    
    
   
    
    
    
}
