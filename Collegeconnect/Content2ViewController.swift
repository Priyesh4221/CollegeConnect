//
//  Content2ViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/27/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class Content2ViewController: UIViewController  {
  
    
    @IBOutlet weak var lecturetitle: UILabel!
    
    @IBOutlet weak var lectureicon: UIImageView!
    
    
    
    @IBOutlet weak var uploadedby: UILabel!
    
    @IBOutlet weak var uploadedon: UILabel!
    
    
    @IBOutlet weak var lectureinfo: UITextView!
    
    
    
    
    @IBOutlet weak var toplabel: UILabel!
    
    @IBOutlet weak var videoimage: UIImageView!
    
    @IBOutlet weak var playbutton: UIButton!

    
    @IBOutlet weak var heightconstraint: NSLayoutConstraint!
    
    
    var passedvideo : recentlecturestruct?
    var info : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.heightconstraint.constant = self.view.frame.height / 2.5
        self.lecturetitle.text = passedvideo?.lectureitem.lecname
        self.toplabel.text = passedvideo?.lectureitem.lecname
        if passedvideo?.lectureitem.type != "video"
        {
            self.lectureicon.image = #imageLiteral(resourceName: "Shape")
        }
        if let u = passedvideo?.lectureitem.uploadedby.capitalized as? String
        {
             self.uploadedby.text = "Uploaded By : \(u.capitalized)"
        }
        if let m = passedvideo?.lectureitem.uploadedon as? String
        {
            self.uploadedon.text = "Uploaded On : \(m.capitalized)"
        }
       
        
        fetchinfo( status: { (success) -> Void in
            if(success)
            {
            }
            else
            {
                print("----------------------------------------Got False")
            }
        })
       
    }
    
    typealias fetcheddata = (_ success:Bool) -> Void
    func fetchinfo(status : @escaping fetcheddata)
    {
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var t = KeychainWrapper.standard.string(forKey: "school")!
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        FIRDatabase.database().reference().child("contents").child(t).child(self.passedvideo?.lectureitem.lecid ?? "").child("info").observeSingleEvent(of: .value) { (info) in
                if let im = info.value as? String
                {
                        self.info = im
                        self.lectureinfo.text = im.capitalized
                        status(true)
                }
                else
                {
                    self.lectureinfo.text = "No Info Available"
                }
            }
        
    }

   
    
    
    
    
  
    @IBAction func playbuttonpressed(_ sender: UIButton) {
    }
    
}

