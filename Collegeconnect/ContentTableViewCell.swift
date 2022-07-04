//
//  ContentTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/21/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase

class ContentTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var icon: UIImageView!
    
    
    @IBOutlet weak var contenttitle: UILabel!
    
    @IBOutlet weak var contentuploadedby: UILabel!
    
    @IBOutlet weak var contentuploadedon: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updatecell(b : lecturestruct)  {
        self.contenttitle.text = b.lecname.capitalized
        self.contentuploadedby.text = b.uploadedby.capitalized
        self.contentuploadedon.text = b.uploadedon
        
        if(b.type != "video")
        {
            icon.image = #imageLiteral(resourceName: "pdfblue")
        }
    }
    
    func updatecellrecent(b: recentlecturestruct)
    {
        
        self.contenttitle.text = b.lectureitem.lecname.capitalized
        self.contentuploadedby.text = b.lectureitem.uploadedby.capitalized
        self.contentuploadedon.text = b.lectureitem.uploadedon
        if(b.lectureitem.type != "video")
        {
            icon.image = #imageLiteral(resourceName: "pdfblue")
        }
        
         
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
