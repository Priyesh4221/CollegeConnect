//
//  ChooseTeacherTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/30/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class ChooseTeacherTableViewCell: UITableViewCell {
    
    
    
  
    @IBOutlet weak var teachername: UIImageView!
    
    
    
    
    @IBOutlet weak var imageheight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var imagewidth: NSLayoutConstraint!
    
    @IBOutlet weak var status: CustomView!
    
    
    
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    func setupcell(x:teacherstruct)
    {
        
        self.name.text = x.name.capitalized
        self.imagewidth.constant = self.frame.size.width/5
        self.imageheight.constant = self.frame.size.width/5
        self.teachername.layer.cornerRadius = self.frame.size.width/5/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
