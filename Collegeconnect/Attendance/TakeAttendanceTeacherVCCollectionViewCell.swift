//
//  TakeAttendanceTeacherVCCollectionViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/13/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class TakeAttendanceTeacherVCCollectionViewCell: UICollectionViewCell {
    
    
   
    @IBOutlet weak var lab: UILabel!
    
    func updatecell(x:String,y:Bool)
    {
        lab.font = lab.font?.withSize(Dataservices.ds.smallfontsize)
         self.layer.cornerRadius = self.frame.size.height / 2
        self.backgroundColor = UIColor.clear
        
        if x.count == 1 {
             self.lab.text = "0\(x)"
        }
        else {
            self.lab.text = x
        }
        
        if y == true {
            self.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
            
        }
    }
}
