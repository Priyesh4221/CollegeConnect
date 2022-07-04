//
//  AllowedClassesForAttendanceTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/3/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class AllowedClassesForAttendanceTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var grade: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updatecell(x : classcodedetails)
    {
        grade.font = grade.font.withSize(Dataservices.ds.midfontsize)
        
        self.grade.text = x.classname.capitalized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
