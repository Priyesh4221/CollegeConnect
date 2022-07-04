//
//  EditAttendanceViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/5/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EditAttendanceViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
  
    
    var receivedresult : [attendancetaken] = []
    var passeddate : String?
    var passedday : String?
    var passedmonth : String?
    var passedyear : String?
    var choppeddate : String?
    var passedclass : String?
    var pc : classcodedetails?
    
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    
    
    
    
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        self.table.delegate = self
        self.table.dataSource = self
        self.upperviewheight.constant = self.view.frame.size.height/4
        var strpd = passeddate?.description.split(separator: " ")

       var each = strpd?.first
        self.datelabel.text = "\(passedday!)-\(passedmonth!)-\(passedyear!)"
        self.choppeddate = "\(each!)"
        self.passedclass = pc?.code
        datelabel.font = datelabel.font?.withSize(Dataservices.ds.largefontsize)
       fetchattendance()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backbtnpressed(_ sender: UIButton) {
    }
    
    
    @IBAction func messagebtnpressed(_ sender: Any) {
    }
    
    
    
    
    func fetchattendance()
    {
        var teacherid = Dataservices.ds.userid
    
        var t = Dataservices.ds.client

        if let s = choppeddate as? String { FIRDatabase.database().reference().child("attendance").child("\(t)").child("\(teacherid)").child("\(self.passedclass!)").child(passedyear!).child(passedmonth!).child("\(self.choppeddate!)").observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String,AnyObject>{
                self.receivedresult = []
                for s in snap {
                    print(s.key)
                        if let det = s.value as? Dictionary<String,AnyObject> {
                            if let name = det["name"] as? String ,  let status = det["status"] as? String {
                                var x = attendancetaken(id: s.key, name: name, status: status)
                                self.receivedresult.append(x)
                            }
                        }
                    }
                self.table.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receivedresult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "editcell", for: indexPath) as? EditAttendanceTableViewCell {
            cell.updatecell(x: receivedresult[indexPath.row])
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create the alert controller
        var currentstatus = receivedresult[indexPath.row].status.lowercased()
        var currentname = receivedresult[indexPath.row].name.capitalized
        var newstatus = ""
        if (currentstatus.lowercased() == "p" || currentstatus.lowercased() == "present" ){
            newstatus = "absent"
        }
        else if (currentstatus.lowercased() == "a" || currentstatus.lowercased() == "absent")
        {
            newstatus = "present"
        }
        let alertController = UIAlertController(title: "Attendance Update", message: "Do you want to switch status of \(currentname) to \(newstatus) ?", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Yes update it", style: UIAlertActionStyle.default) {
            UIAlertAction in
           
            if newstatus == "absent"
            {
                
                self.updateattendance(id: self.receivedresult[indexPath.row].id, status: "a") { (su) in
                    if(su) {
                        self.receivedresult[indexPath.row].status = "a"
                        self.table.reloadData()
                        print("Present Yes")
                    }
                    else
                    {
                         print("Present No")
                    }
                }
                
            }
            else
            {
                self.updateattendance(id: self.receivedresult[indexPath.row].id, status: "p") { (su) in
                    if(su) {
                        self.receivedresult[indexPath.row].status = "p"
                        self.table.reloadData()
                         print("Absent Yes")
                    }
                    else
                    {
                         print("Absent No")
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "No Cancel it", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }

     typealias fetcheddata = (_ success:Bool) -> Void
    func updateattendance(id : String ,status : String,ex : @escaping fetcheddata)
    {
       
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        
      
      
        FIRDatabase.database().reference().child("students").child("\(t)").child("\(id)").child("attendance").child(passedyear!).child(passedmonth!).child("\(choppeddate!)").setValue("\(status)" as String) { (err, ref) in
            if err != nil
            {
                print("Error setting attendance")
                ex(false)
            }
            else
            {
                print("Ref is \(ref)")
                
                
                
                FIRDatabase.database().reference().child("attendance").child("\(t)").child(s).child("\(self.passedclass!)").child(self.passedyear!).child(self.passedmonth!).child("\(self.choppeddate!)").child(id).child("status").setValue(status, withCompletionBlock: { (err, ref) in
                        if err != nil
                        {
                            print("Could not Complete Posting Attendance")
                            ex(false)
                        }
                        else
                        {
                            ex(true)
                            self.table.reloadData()
                        }
                    })
                    
                    
                    
                    
                
                    
                }
                
            }
        }
    
   

}
