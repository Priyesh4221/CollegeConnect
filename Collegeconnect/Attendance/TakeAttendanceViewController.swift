//
//  TakeAttendanceViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/5/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class TakeAttendanceViewController: UIViewController {
    
    
    @IBOutlet weak var datelabel: UILabel!
    
    @IBOutlet weak var classname: UILabel!
    
    @IBOutlet weak var studentname: UILabel!
    
    @IBOutlet weak var studentimage: UIImageView!
    
    
    @IBOutlet weak var countinglabel: UILabel!
    
    
    @IBOutlet weak var widthimage: NSLayoutConstraint!
    
    @IBOutlet weak var studentimageouterviewwidth: NSLayoutConstraint!
    var currentindex = 0
    
    var passeddate : String?
    var passedday : String?
    var passedmonth : String?
    var passedyear : String?
    var choppeddate : String?
    var passedclass : String?
    var pc :classcodedetails?
    
    @IBOutlet weak var studentimageouterview: RoundedView!
    
    var allstudents : [studentforattendance] = []
    var tg : UISwipeGestureRecognizer = UISwipeGestureRecognizer()
    

    @IBOutlet weak var absentbtn: UIButton!
    
    @IBOutlet weak var presentbtn: UIButton!
    
    @IBOutlet weak var cancelbtn: UIButton!
    
    
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.studentimageouterviewwidth.constant = self.view.frame.width * 0.6
    self.studentimageouterview.layer.cornerRadius = self.studentimageouterview.frame.size.height / 2
        self.upperviewheight.constant = self.view.frame.size.height/5
        
        setupfont()
        if let vc = pc?.code as? String {
             self.passedclass=vc
        }
       
        print("################# \(self.passedclass!)")
        self.classname.text = self.pc?.classname.capitalized
        
        self.studentimage.layer.cornerRadius = self.studentimage.frame.size.height/2
        self.studentimage.image = UIImage(named: "academicinfo")
        
        tg = UISwipeGestureRecognizer(target: self, action: #selector(self.handleswipe(_:)))
        tg.isEnabled = true
        self.studentimage.addGestureRecognizer(tg)
        var strpd = passeddate?.description.split(separator: " ")
        var each = strpd?.first
        self.datelabel.text = "\(passedday!)-\(passedmonth!)-\(passedyear!)"
        self.choppeddate = "\(each!)"
      
        fetchstudents( status: { (success) -> Void in
            if(success)
            {
                self.studentname.text = self.allstudents.first?.name

            }
            else
            {
                print("----------------------------------------Got False \(self.passedclass)")
            }
        })
        

        // Do any additional setup after loading the view.
    }
    
    

    func setupfont()
    {
        datelabel.font = datelabel.font.withSize(Dataservices.ds.largefontsize)
        classname.font = classname.font.withSize(Dataservices.ds.midfontsize)
        countinglabel.font = countinglabel.font.withSize(Dataservices.ds.midfontsize)
        studentname.font = studentname.font.withSize(Dataservices.ds.midfontsize)
        cancelbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        absentbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        presentbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
    }
    
    
    
    @IBAction func imageswipped(_ sender: UISwipeGestureRecognizer) {
        
        print("Second swipe \(sender.direction)")
    }
    
    
    
    
    
    
    
    @objc func handleswipe(_ sender: UISwipeGestureRecognizer)
    {
        print("Image Tapped \(sender.direction)")
        switch sender.direction {
        case .right:
            self.studentimage.backgroundColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        case .left:
            self.studentimage.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        default:
            print("none")
        }
    }
    
    typealias fetcheddata = (_ success:Bool) -> Void
    func fetchstudents(status : @escaping fetcheddata)
    {
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = self.passedclass!
        
        print("\(c )is the passedclass")
        
        FIRDatabase.database().reference().child("classpopulation").child("\(t)").observeSingleEvent(of: .value) { (snap) in
                if(snap.hasChild("\(self.passedclass!)")) {
                
                    FIRDatabase.database().reference().child("classpopulation").child("\(t)").child("\(self.passedclass!)").observeSingleEvent(of: .value) { (snapshot) in
                        print("Reaching here or not")
                        if let snap = snapshot.value as? Dictionary<String,AnyObject> {
                            for st in snap {
                                print("helooooooooooooooooooooooo \(st.key)")
                                self.fetchfurther( innerstatus: { (s) -> Void in
                                    self.studentname.text = self.allstudents.first?.name
                                    self.countinglabel.text = "1/\(self.allstudents.count)"
                                },id: st.key)
                                
                            }
                            print("Ending")
                            status(true)
                        }
                        else
                        {
                            status(false)
                        }
                    }
                }
                else
                {
                    self.studentname.text = "Sorry no students are enrolled in this course yet."
                    self.studentimage.isHidden = true
                    self.absentbtn.isHidden = true
                    self.presentbtn.isHidden = true
                    self.cancelbtn.setTitle("Ok", for: .normal)
                    self.countinglabel.isHidden = true
                    self.studentimageouterview.isHidden = true

                }
            }
        
        
        
    }
    
    
    func fetchfurther(innerstatus : @escaping fetcheddata , id : String)
    {
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = self.passedclass
        print("Searching for \(id)")
    FIRDatabase.database().reference().child("students").child("\(t)").child("\(id)").child("basic").observeSingleEvent(of: .value) { (innersnap) in
            
            
            if let innersnapshot = innersnap.value as? Dictionary<String,AnyObject>{
                var x = studentforattendance(name: innersnapshot["name"] as? String ?? "", profilepicture: (innersnapshot["profilepicture"] as? String)! , id: id)
                self.allstudents.append(x)
                print(x.name)
                
                self.downloadimage(done: { (res) in
                    
                }, z: "\(x.id).jpg")
                print("heloooooooooooo \(x.name)")
                innerstatus(true)
            }
        }
    }
    
    
    
   
    
    func downloadimage(done : @escaping fetcheddata,z:String)
    {
        print(z)
        var url = z
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
                Dataservices.ds.profilecache.setObject(image ?? defaultimage!, forKey: "\(z.split(separator: ".")[0])" as NSString)
                if(z.split(separator: ".")[0] == self.allstudents[0].id) {
                    self.studentimage.image = image
                }
                done(true)
            }
        }
    }
    
    
    
    

    @IBAction func presentclicked(_ sender: UIButton) {
        updateattendance(status: "p", ex: { (ee) -> Void in
            if(ee)
            {
                self.currentindex = self.currentindex + 1
                if self.currentindex < self.allstudents.count {
                    self.studentimage.isHidden = false
                    self.studentname.text = self.allstudents[self.currentindex].name
                    var nextid = self.allstudents[self.currentindex].id
                    print(nextid)
                    var pp = Dataservices.ds.profilecache.object(forKey: nextid as NSString)
                    print(pp)
                    if(pp == nil)
                    {
                        pp = UIImage(named: "academicinfo")
                    }
                    self.studentimage.image = pp
                    self.countinglabel.text = "\(self.currentindex + 1)/\(self.allstudents.count)"
                    self.studentimage.isHidden = false
                    self.absentbtn.isHidden = false
                    self.presentbtn.isHidden = false
                    self.cancelbtn.setTitle("Cancel", for: .normal)
                }
                else if self.currentindex == self.allstudents.count
                {
                    self.studentname.text = "You are done taking attendance of all students"
                    self.studentimage.isHidden = true
                    self.absentbtn.isHidden = true
                    self.presentbtn.isHidden = true
                    self.cancelbtn.setTitle("Done", for: .normal)
                }
                else
                {
                    print("Error Taking Attendance ")
                }
            }
            else
            {
                print("----------------------------------------Got False")
            }
        })
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dateFormatter.string(from:Date())
        print(dateString)
        
    }
    
    
    @IBAction func absentclicked(_ sender: UIButton) {
        updateattendance(status: "a", ex: { (ee) -> Void in
            if(ee)
            {
                self.currentindex = self.currentindex + 1
                if self.currentindex < self.allstudents.count {
                    self.studentname.text = self.allstudents[self.currentindex].name
                    self.countinglabel.text = "\(self.currentindex + 1)/\(self.allstudents.count)"
                    var nextid = self.allstudents[self.currentindex].id
                    var pp = Dataservices.ds.profilecache.object(forKey: nextid as NSString)
                    if(pp == nil)
                    {
                        pp = UIImage(named: "academicinfo")
                    }
                    self.studentimage.image = pp
                    self.studentimage.isHidden = false
                    self.absentbtn.isHidden = false
                    self.presentbtn.isHidden = false
                    self.cancelbtn.setTitle("Cancel", for: .normal)
                }
                else if self.currentindex == self.allstudents.count
                {
                    self.studentname.text = "You are done taking attendance of all students"
                    self.studentimage.isHidden = true
                    self.absentbtn.isHidden = true
                    self.presentbtn.isHidden = true
                    self.cancelbtn.setTitle("Done", for: .normal)
                }
                else
                {
                    print("Error Taking Attendance ")
                }
            }
            else
            {
                print("----------------------------------------Got False")
            }
        })
    }
    
    
    func findmonth(x:String) -> Int {
        var lx = x.lowercased()
        switch lx {
        case "jan":
            return 1
        case "feb":
            return 2
        case "mar":
            return 3
        case "apr":
            return 4
        case "may":
            return 5
        case "june":
            return 6
        case "july":
            return 7
        case "aug":
            return 8
        case "sep":
            return 9
        case "oct":
            return 10
        case "nov":
            return 11
        case "dec":
            return 12
        default:
            return 0
        }
    }
    
    
    @IBAction func cancelbtnclicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion:nil)
    }
    
    
    
    func updateattendance(status : String,ex : @escaping fetcheddata)
    {
       
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
       print(currentindex)
        print(self.allstudents.count)
        var nid = self.allstudents[currentindex].id
        var name = self.allstudents[currentindex].name
        FIRDatabase.database().reference().child("students").child("\(t)").child("\(nid)").child("attendance").child(passedyear!).child(passedmonth!).child("\(choppeddate!)").setValue("\(status)" as String) { (err, ref) in
            if err != nil
            {
                print("Error setting attendance")
                ex(false)
            }
            else
            {
                print("Ref is \(ref)")
                
                
                
                FIRDatabase.database().reference().child("attendance").child("\(t)").child(s).child("\(self.passedclass!)").child(self.passedyear!).child(self.passedmonth!).child("\(self.choppeddate!)").child(nid).updateChildValues(["name":name,"status":status]) { (err, ref) in
                        if err != nil
                        {
                                print("Could not Complete Posting Attendance")
                            ex(false)
                        }
                        else
                        {
                            ex(true)
                        }
                    }
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
