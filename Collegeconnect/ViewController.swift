//
//  ViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/11/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class ViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
 
    
    var stu : student!
    {
        didSet
        {
            updateui()
            
            
        }
    }
    var selectedcategory = ""
    var sttendancetype = ""
    var arraycontents = ["academicinfo","timetable","assessment","attendance","elearning","event","notice","profile","syallabus"]
    @IBOutlet weak var schoolname: UILabel!
    
    
    @IBOutlet weak var studentname: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var upperf: UIView!
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    @IBOutlet weak var urgentnotice: UILabel!
    
    
    
    var currentclass = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.delegate = self
        self.collection.dataSource = self
        self.stu = student(name: "", progress: 0, classcode: "",classname : "",schoolname:"", assessments: [], attendance: [], reviews: [], lecturesviewed: [])
      
        setfontsize()
        fetchmore()

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func setfontsize()
    {
        schoolname.font = schoolname.font.withSize(Dataservices.ds.smallfontsize)
        studentname.font = studentname.font.withSize(Dataservices.ds.smallfontsize)
        urgentnotice.font = urgentnotice.font.withSize(Dataservices.ds.smallfontsize * 0.6)
    }
    
    func fetchmore()
    {
       print(Dataservices.ds.client)
        print(Dataservices.ds.userid)
        var cat = ""
        if(Dataservices.ds.role == "student")
        {
                cat = "students"
        }
        else if(Dataservices.ds.role == "teacher")
        {
            cat = "teachers"
        }
        else if(Dataservices.ds.role == "parent")
        {
            cat = "parents"
        }
        else{
            cat = "admins"
        }
    
    FIRDatabase.database().reference().child("\(cat)").child("\(Dataservices.ds.client)").child("\(Dataservices.ds.userid)").observeSingleEvent(of: .value) { (basicsnap) in
        
        if let bb = basicsnap.value as? Dictionary<String,AnyObject> {
            
            if(Dataservices.ds.role == "student") {
                Dataservices.ds.attendancetype = (bb["attendancetype"] as? String)!
                print("Attendance type is \(Dataservices.ds.attendancetype)")
            }
            else if(Dataservices.ds.role == "teacher")
            {
                if let allclasses = bb["allotedclasses"] as? Dictionary<String,AnyObject> {
                    for e in allclasses {
                        Dataservices.ds.enrolledclasses[e.key] = "\(e.value)"
                    }
                    print("Enrolled classes are ")
                    print(Dataservices.ds.enrolledclasses)
                }
            }
            
            if let basicdata = bb["basic"] as? Dictionary<String,AnyObject> {
                Dataservices.ds.username = basicdata["name"] as! String
        Dataservices.ds.userprogress = basicdata["progress"] as! String
                self.studentname.text = Dataservices.ds.username
                self.downloadimage(done: { (dwd) in
                    
                }, z: Dataservices.ds.userid)
                
            }
            
        }
            
        
            }
        
        FIRDatabase.database().reference().child("clients").child(Dataservices.ds.client).observeSingleEvent(of: .value) { (snappy) in
                if let snap = snappy.value as? Dictionary<String,AnyObject> {
                    Dataservices.ds.schoolname = snap["universityname"] as! String
                    self.schoolname.text = Dataservices.ds.schoolname
                    print("Client name is \(Dataservices.ds.schoolname )")
                    Dataservices.ds.expiry = snap["planexpireson"] as! String
                    self.setupcurrenttime()
                    
                }
            }
    }
    
    
    
     typealias fetcheddata = (_ success:Bool) -> Void
    func downloadimage(done : @escaping fetcheddata,z:String)
    {
        print(z)
        var url = "\(z).jpg"
        var ref = FIRStorage.storage().reference().child("profilepictures/\(url)")
        print(ref)
        ref.data(withMaxSize: 1*1024*1024) { (data, err) in
            if let error = err {
                print("error downloading \(err?.localizedDescription)")
                done(false)
            } else {
                // Data for "images/island.jpg" is returned
                print("Downloaded")
                print(data)
                print("Downloaded")
                let image = UIImage(data: data!)
                let defaultimage = UIImage(named: "academicinfo")
                Dataservices.ds.profilecache.setObject(image ?? defaultimage!, forKey: "\(z)" as NSString)
                
                    self.image.image = image
                
                done(true)
            }
        }
    }
    
    func setupcurrenttime()
    {
        var x = Date()
        var strpd = x.description.split(separator: " ")
        var each = strpd.first!
        var datearray = each.split(separator: "-")
        print("Set up current time")
        print(datearray.count)
        if datearray.count == 3 {
            var yearpart = Int(datearray[0])!
            var monthpart = Int(datearray[1])!
            var daypart = Int(datearray[2])!
            
            
            
            var expireddate = Dataservices.ds.expiry.split(separator: "/")
            var ed = Int(expireddate[0])!
            var em = Int(expireddate[1])!
            var ey = Int(expireddate[2])!
            print("\(yearpart)  \(ey)")
            if(ey > yearpart)
            {
                Dataservices.ds.isplanexpired = false
            }
            else if(ey == yearpart && em > monthpart)
            {
                Dataservices.ds.isplanexpired = false
            }
            else if(ey == yearpart && em == monthpart && ed >= daypart)
            {
                Dataservices.ds.isplanexpired = false
            }
            else
            {
                Dataservices.ds.isplanexpired = true
            }
            
            if(Dataservices.ds.isplanexpired == true) {
             var k =    Dataservices.ds.showalert(head: "Account no longer valid", title: "Please contact your school authority to make your account working again.", btntitle: "Ok")
                present(k, animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    
    
    
    func updateui()
    {
        self.schoolname.text = Dataservices.ds.client
        self.studentname.text = Dataservices.ds.userid
    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arraycontents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vccell", for: indexPath) as? VCCollectionViewCell
        {
            cell.updatecell(x: self.arraycontents[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        print(self.arraycontents[indexPath.row])
        print(Dataservices.ds.role)
            
            
            if self.arraycontents[indexPath.row] == "attendance" && ( Dataservices.ds.role == "student" ||  Dataservices.ds.role == "parent"){
                
                if(Dataservices.ds.attendancetype == "static") {
                        performSegue(withIdentifier: "studentattendancestatic", sender: nil)
                }
                else {
                    performSegue(withIdentifier: "studentattendancedynamic", sender: nil)
                    
                }
                
                
            }
            else if self.arraycontents[indexPath.row] == "attendance" && ( Dataservices.ds.role == "teacher" ||  Dataservices.ds.role == "admin")
            {
                self.selectedcategory = "attendance"
                performSegue(withIdentifier: "teachertimetableshown", sender: nil)
            }
            
            if self.arraycontents[indexPath.row] == "timetable" && ( Dataservices.ds.role == "student" ||  Dataservices.ds.role == "parent") {
                print("Enrolledclassed ")
                print(Dataservices.ds.enrolledclasses)
                for each in Dataservices.ds.enrolledclasses {
                   self.currentclass =  each.key
                    break
                }
                print(Dataservices.ds.client)
                print(self.currentclass)
                FIRDatabase.database().reference().child("timetable").child(Dataservices.ds.client).child(self.currentclass).child("type").observeSingleEvent(of: .value) { (sss) in
                    
                            if let v = sss.value as? String {
                                print(v)
                                if(v=="fixed") {
                                    self.performSegue(withIdentifier: "studentstatictimetable", sender: nil)
                                }
                                else if(v=="variable"){
                                    self.performSegue(withIdentifier: "studentdynamictimetable", sender: nil)
                                }
                            }
                    
                    
                    }
                
            }
            else if self.arraycontents[indexPath.row] == "timetable" && (
                Dataservices.ds.role == "teacher" ||  Dataservices.ds.role == "admin")
            {
                self.selectedcategory = "timetable"
                performSegue(withIdentifier: "teachertimetableshown", sender: nil)
            }
            
            
            
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cg = CGSize(width: self.view.frame.size.width/3.5, height: self.view.frame.size.width/3)
        return cg
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? AllowedClassesForAttendanceViewController {
            seg.category = self.selectedcategory
        }
        else if let seg = segue.destination as? TeacherTimeTableoneViewController {
            seg.passedclass = self.currentclass
        }
        else if let seg = segue.destination as? TeacherTimeTableVariableViewController {
            print("Check here")
            print(self.selectedcategory)
            seg.passedclasscode = self.currentclass
        }
    }



}

