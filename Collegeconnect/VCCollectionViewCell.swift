//
//  VCCollectionViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/11/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class VCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outerview: UIView!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var im: UIImageView!
    func updatecell(x : String)
    {
      
    label.font = label.font.withSize(Dataservices.ds.smallfontsize * 0.8)
        if let i = UIImage(named: x)
        {
            self.im.image = i
            self.label.text = x.capitalized
        }
        else if x == "timetable" {
            self.im.image = UIImage(named: "routine")
            self.label.text = x.capitalized
        }
    }
}
