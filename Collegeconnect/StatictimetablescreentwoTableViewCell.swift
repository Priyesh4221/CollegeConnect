//
//  StatictimetablescreentwoTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 10/29/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class StatictimetablescreentwoTableViewCell: UITableViewCell {

  
    @IBOutlet weak var period: UILabel!
    
    @IBOutlet weak var subject: UILabel!
    
    func updatecell(x:String,y:String){
        self.period.text = x
        self.subject.text = y
        period.font = period.font?.withSize(Dataservices.ds.midfontsize)
        subject.font = subject.font?.withSize(Dataservices.ds.midfontsize)
    }
}
