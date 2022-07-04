//
//  TeacherTimeTableDay1CollectionViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/20/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class TeacherTimeTableDay1CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerview: CustomView!
    @IBOutlet weak var dayname: UILabel!
    
    func update(x:String,active:Bool)
    {
         dayname.font = dayname.font?.withSize(Dataservices.ds.smallfontsize)
        self.dayname.text = x
        if active {
           
            self.outerview.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
            self.dayname.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.outerview.layer.borderWidth = 1
            self.outerview.layer.borderColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        }
        else
        {
            self.outerview.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
            self.dayname.textColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
            self.outerview.layer.borderWidth = 1
            self.outerview.layer.borderColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        }
    }
    
}
