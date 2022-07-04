//
//  AttendanceCollectionViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/11/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class AttendanceCollectionViewCell: UICollectionViewCell {
   
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var date: UILabel!
    
    func updatecell(n : attendancestruct)
    {
        self.date.text = "\(n.date.prefix(2))"
        if(n.status == "p")
        {
            self.view.backgroundColor = #colorLiteral(red: 0.01568627451, green: 0.2235294118, blue: 0.1529411765, alpha: 1)
        }
        else if(n.status == "a")
        {
            self.view.backgroundColor = #colorLiteral(red: 0.2588235294, green: 0.05098039216, blue: 0.03529411765, alpha: 1)
        }
        else
        {
            self.view.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        }
    }
    
    
}
