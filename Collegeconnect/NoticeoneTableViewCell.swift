//
//  NoticeoneTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 12/23/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class NoticeoneTableViewCell: UITableViewCell {

    
    @IBOutlet weak var teachername: UILabel!
    
    @IBOutlet weak var notice: UILabel!
    
    @IBOutlet weak var dateandtime: UILabel!
    
    func updatecell(z : news)
    {
        teachername.font = teachername.font?.withSize(Dataservices.ds.smallfontsize)
        notice.font = notice.font?.withSize(Dataservices.ds.midfontsize)
        dateandtime.font = dateandtime.font?.withSize(Dataservices.ds.smallfontsize)
        
        self.teachername.text = z.postedby.capitalized
        self.notice.text = z.content.capitalized
        self.dateandtime.text = "\(z.postedon)"
    }

}
