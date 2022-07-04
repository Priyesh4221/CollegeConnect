//
//  StaticTimeTablescreenoneTableViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 10/29/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class StaticTimeTablescreenoneTableViewCell: UITableViewCell {

    @IBOutlet weak var field: UILabel!
    func updatecell(x:String) {
        self.field.text = x
        field.font = field.font?.withSize(Dataservices.ds.midfontsize)
    }

}
