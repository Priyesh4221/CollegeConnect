//
//  AllowedClassesForAttendanceViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/3/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class AllowedClassesForAttendanceViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
 
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    var allclasses : [classcodedetails] = []
    
    @IBOutlet weak var headerview: CustomView!
    
    @IBOutlet weak var headerlabel: UILabel!
    @IBOutlet weak var table: UITableView!
    
    var allowedclasses : [String] = []
    var selectedclassfrom : classcodedetails?
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    
    @IBOutlet weak var messagebtn: UIButton!
    
    
    
    var category = "attendance"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.upperviewheight.constant = self.view.frame.size.height / 3.5
      self.fetchdata()

        // Do any additional setup after loading the view.
         headerlabel.font = headerlabel.font.withSize(Dataservices.ds.largefontsize)
    }
    
    
    
    @IBAction func backbtnpressed(_ sender: UIButton) {
    }
    
    
    @IBAction func messagebtnpressed(_ sender: UIButton) {
    }
    
    
    
    
    func fetchdata()
    {
        
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        
       
        
        FIRDatabase.database().reference().child("teachers").child(t).child(s).observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String,AnyObject> {
                var name = Dataservices.ds.username
                print(name)
                if let classesids = snap["allotedclasses"] as? Dictionary<String,AnyObject> {
                    for c in classesids {
                        print(c.key)
                        self.fetchfurtherdetails(x: c.key, y: name as! String) { (su) in
                            if(su) {
                                print("Received one class")
                                self.table.reloadData()
                            }
                            else {
                                print("Failed Fetching one class")
                            }
                        }
                    }
                }
            }
        }
    }
    
    typealias fetcheddata = (_ success:Bool) -> Void
    func fetchfurtherdetails(x:String,y:String,status: @escaping fetcheddata)
    {
        
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        
        FIRDatabase.database().reference().child("classcodes").child(x).observeSingleEvent(of: .value) { (snapi) in
            var code = snapi.key as? String
            if let snap = snapi.value as? Dictionary<String,AnyObject> {
                var classname = ""
                var ttc = ""
                var classtaughtby : [String] = []
                var noofstudentsenrolled = 0
                var testspermittedids : [String] = []
                if let cn = snap["classname"] as? String {
                    classname = cn
                }
                if let ttcc = snap["timetabletype"] as? String {
                    ttc = ttcc
                }
                if let senrolled = snap["noofstudentsenrolled"] as? Int {
                    noofstudentsenrolled = senrolled
                }
                if let teacherstaking = snap["classtaughtby"] as? Dictionary<String,AnyObject> {
                    for t in teacherstaking {
                        classtaughtby.append(t.key)
                    }
                }
                if let teststaking = snap["testspermitted"] as? Dictionary<String,AnyObject> {
                    for te in teststaking {
                        testspermittedids.append(te.key)
                    }
                }
                
                var x = classcodedetails(code: code ?? "", classname: classname, taughtby: classtaughtby, noofstudents: noofstudentsenrolled, testspermittedid: testspermittedids, teachername: y,timetabletype : ttc)
                print(x)
                self.allclasses.append(x)
                status(true)
            }
            else
            {
                status(false)
            }
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.allclasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "allowedcell", for: indexPath) as? AllowedClassesForAttendanceTableViewCell {
            cell.updatecell(x: allclasses[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedclassfrom = allclasses[indexPath.row]
        if self.category == "attendance" {
            performSegue(withIdentifier: "classtotakeattendance", sender: nil)
        }
        else if self.category == "timetable" {
            if(allclasses[indexPath.row].timetabletype == "variable") {
                performSegue(withIdentifier: "teacherdynamictimetable", sender: nil)
            }
            else
            {
                performSegue(withIdentifier: "teacherstatictimetable", sender: nil)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height / 8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? TakeAttendanceTeacherViewController
        {
            seg.pc = self.selectedclassfrom
        }
        else if let seg = segue.destination as? TeacherTimeTableoneViewController
        {
            print(self.selectedclassfrom?.code)
            seg.passedclass = self.selectedclassfrom!.code
        }
        else if let seg = segue.destination as? TeacherTimeTableVariableViewController
        {
            print(self.selectedclassfrom?.code)
            seg.passedclasscode = self.selectedclassfrom!.code
        }
    }
    

}
