//
//  AssessmentCollectionViewCell.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/25/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class AssessmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var testpostedby: UILabel!
    @IBOutlet weak var testtitle: UILabel!
    
    @IBOutlet weak var testpostedon: UILabel!
    
    @IBOutlet weak var testsubject: UILabel!
    
    @IBOutlet weak var outercover: CustomView!
    
    @IBOutlet weak var loaderheight: NSLayoutConstraint!
    
  
    @IBOutlet weak var loader: Circularloader!
    
    @IBOutlet weak var loaderwidth: NSLayoutConstraint!
    
    func updatecell(t :test)
    {
        self.loader.isHidden = true
        self.testtitle.text = t.topic.capitalized
        self.testpostedby.text = "Posted by \(t.postedby.capitalized)"
        self.testpostedon.text = "Posted on \(t.postedon)"
        self.testsubject.text = "Subject  \(t.subject)"
//        self.sideimage.image = #imageLiteral(resourceName: "academicinfo")
//        self.sideimage.isHidden = true
        self.testtitle.font = testtitle.font.withSize(Dataservices.ds.midfontsize)
         self.testpostedby.font = testpostedby.font.withSize(Dataservices.ds.smallfontsize)
        self.testpostedon.font = testpostedon.font.withSize(Dataservices.ds.smallfontsize)
         self.testsubject.font = testsubject.font.withSize(Dataservices.ds.smallfontsize)
    }
    func updatecell(a : assessmentstruct)
    {
        self.loader.isHidden = false
        self.loaderwidth.constant = self.outercover.frame.size.width / 3
        self.loaderheight.constant = self.outercover.frame.size.width / 3
        self.testtitle.text = "\(a.marks) out of \(a.totalmarks)"
        self.testpostedby.text = "\(a.topic.capitalized)"
        self.testpostedon.text = "Test Taken On :   \(a.testtakenon)"
        self.testsubject.text = ""
//         self.sideimage.image = #imageLiteral(resourceName: "attendance")
//        self.sideimage.isHidden = false
        self.testtitle.font = testtitle.font.withSize(Dataservices.ds.midfontsize)
        self.testpostedby.font = testpostedby.font.withSize(Dataservices.ds.midfontsize)
        self.testpostedon.font = testpostedon.font.withSize(Dataservices.ds.smallfontsize)
        self.testsubject.font = testsubject.font.withSize(Dataservices.ds.smallfontsize)
        
        if let tm = a.totalmarks as? Int {
            loader.safePercent = tm
        }
       
            loader.labelSize = 0
        
        var percentage  = Double(a.marks) / Double(a.totalmarks)
        
        loader.setProgress(to: percentage, withAnimation: true)
        loader.actualradius = self.outercover.frame.size.width
    }
    
    
}
