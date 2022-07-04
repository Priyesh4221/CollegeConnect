//
//  AttendancePerClassTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/16/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class AttendancePerClassTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var subject: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var timings: UILabel!
    
    
    @IBOutlet weak var teacher: UILabel!
    
    
    @IBOutlet weak var customview: CustomView!
    
    func updatecell(x:attendanceperclasswise)
    {
        setupfont()
        self.subject.text = x.subject.capitalized
        self.teacher.text = x.takenby.capitalized
        self.timings.text = "\(x.begins) - \(x.ends)"
        if(x.attendancestatus == "p")
        {
            self.status.text = "Present"
            self.customview.layer.borderColor = UIColor.green.cgColor
            self.customview.layer.borderWidth = 1
            self.customview.layer.cornerRadius = 5

        }
        else
        {
            self.status.text = "Absent"
            self.customview.layer.borderColor = UIColor.red.cgColor
            self.customview.layer.borderWidth = 1
            self.customview.layer.cornerRadius = 5

            
        }
        
    }
    
    
    func setupfont()
    {
        subject.font = subject.font.withSize(Dataservices.ds.midfontsize)
        teacher.font = teacher.font.withSize(Dataservices.ds.smallfontsize)
        
        timings.font = timings.font.withSize(Dataservices.ds.smallfontsize)
        status.font = status.font.withSize(Dataservices.ds.smallfontsize)
        

        
    }

   
}
