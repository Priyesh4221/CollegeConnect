//
//  Dataservices.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 10/27/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import Foundation
import UIKit

class Dataservices
{
    static var ds = Dataservices()
    
    var userid : String = ""
    var client : String = ""
    var role : String = ""
    var schoolname = ""
    var username = ""
    var userprogress = ""
    var expiry = ""
    var isplanexpired = false
    var enrolledclasses = Dictionary<String,String>()
    var attendancetype = ""
    
    
    var smallfontsize : CGFloat = 16
    var midfontsize : CGFloat = 20
    var largefontsize : CGFloat = 32
    
    var profilecache: NSCache<NSString, UIImage> = NSCache()
    
    func showalert(head : String , title : String ,btntitle :String) -> UIAlertController {
        let actionSheetController = UIAlertController (title: "\(head)", message: "\(title)", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //Add Cancel-Action
        actionSheetController.addAction(UIAlertAction(title: "\(btntitle)", style: UIAlertActionStyle.cancel, handler: nil))
        
          return actionSheetController
    }
    
    
}
