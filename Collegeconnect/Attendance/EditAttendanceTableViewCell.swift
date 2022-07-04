//
//  EditAttendanceTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/5/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class EditAttendanceTableViewCell: UITableViewCell {

    
    
    var passeddate : String?
    
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updatecell(x : attendancetaken)
    {
        name.font = name.font?.withSize(Dataservices.ds.smallfontsize)
    status.font = status.font?.withSize(Dataservices.ds.smallfontsize)
        self.name.text = x.name.capitalized
        self.status.text = x.status.capitalized
    }

    

}
