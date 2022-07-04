//
//  TeacherTimeTableTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/22/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class TeacherTimeTableTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var periodnumber: UILabel!
    
    @IBOutlet weak var subjectname: UILabel!
    

    
    func updatecell(period : Int,sub : String)
    {
        var periodtext = ""
        if period == 0
        {
            periodtext = "0th"
        }
        else if period == 1
        {
            periodtext = "1st"
        }
        else if period == 2
        {
            periodtext = "2nd"
        }
        else if period == 3
        {
            periodtext = "3rd"
        }
        else
        {
            periodtext = "\(period)th"
        }
        self.periodnumber.text = periodtext
        self.subjectname.text = sub.capitalized
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
