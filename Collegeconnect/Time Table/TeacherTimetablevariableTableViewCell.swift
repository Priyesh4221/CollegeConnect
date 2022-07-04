//
//  TeacherTimetablevariableTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/23/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class TeacherTimetablevariableTableViewCell: UITableViewCell {
    

    var tappedclass : timetablevariable?
    
    @IBOutlet weak var subjectname: UILabel!
    
    @IBOutlet weak var editbutton: UIButton!
    
    @IBOutlet weak var span: UILabel!
    
    @IBOutlet weak var room: UILabel!
    
    @IBOutlet weak var teachername: UILabel!
    
    @IBOutlet weak var remarks: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updatecell(x:timetablevariable)
    {
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var role = KeychainWrapper.standard.string(forKey: "role")!
        s = "teacher1234"
        if s == x.teacherid || role == "admin" {
            self.selectionStyle = .default
            editbutton.isHidden = false
            self.isUserInteractionEnabled = true
            
        }
        else
        {
            self.selectionStyle = .none
            editbutton.isHidden = true
            self.isUserInteractionEnabled = false
        }
        self.tappedclass = x
        print("got")
        print(x)
        self.subjectname.text = x.subject.capitalized
        self.span.text = "\(x.begins) - \(x.ends)"
        self.room.text = "Room - \(x.room)"
        self.remarks.text = x.reminders.capitalized
        self.teachername.text = x.teachername.capitalized
        
        
               subjectname.font = subjectname.font?.withSize(Dataservices.ds.midfontsize)
        
               span.font = span.font?.withSize(Dataservices.ds.smallfontsize)
        
               room.font = room.font?.withSize(Dataservices.ds.smallfontsize)
        
               teachername.font = teachername.font?.withSize(Dataservices.ds.smallfontsize)
        
               remarks.font = remarks.font?.withSize(Dataservices.ds.smallfontsize)
    }
    
    

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
