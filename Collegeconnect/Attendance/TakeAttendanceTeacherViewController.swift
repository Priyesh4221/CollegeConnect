//
//  TakeAttendanceTeacherViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/3/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class TakeAttendanceTeacherViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    

    @IBOutlet weak var collectionouterview: CustomView!
    
    @IBOutlet weak var day: UIButton!
    
    @IBOutlet weak var month: UIButton!
    
    @IBOutlet weak var year: UIButton!
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var collectionheader: UILabel!
    
    @IBOutlet weak var collectiondone: UIButton!
    
    
    @IBOutlet weak var collectioncancel: UIButton!
    
    
    @IBOutlet weak var headertitle: UILabel!
    
    
    @IBOutlet weak var attendancestatus: UILabel!
    
    
    @IBOutlet weak var editattendancebtnoutlet: UIButton!
    
    @IBOutlet weak var retakeattendancebtnoutlet: UIButton!
    
    
    
    @IBOutlet weak var upperviewhieght: NSLayoutConstraint!
    
    
    
    var pc : classcodedetails?
    var passedclass : String?
    
    var yearpart = ""
    var monthpart = ""
    var daypart = ""
    
    var daysinmonth = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    var allmonths = ["January","February","March","April","May","June","July","August","September","October","Novermber","December"]
    
    var collectionviewshown = "days"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headertitle.text = pc?.classname.capitalized
        self.passedclass = pc?.code
        self.collection.delegate = self
        self.collection.dataSource = self
        setupcurrenttime()
        self.collection.reloadData()
        self.collectionouterview.isHidden = true
        setupfont()
        
    self.upperviewhieght.constant = self.view.frame.size.height/4
     
        self.day.setTitle(daypart, for: .normal)
        self.month.setTitle(monthpart, for: .normal)
        self.year.setTitle(yearpart, for: .normal)
        
        print("Check For Attendance")
        var fulldate = "\(daypart)\(monthpart)\(yearpart)"
        print(fulldate)
        var y = "23062019"
        
        checkforattendance(x:fulldate, status: { (success) -> Void in
            if(success)
            {
            }
            else
            {
                self.attendancestatus.text = "Attendance Not Taken Yet."

                self.editattendancebtnoutlet.isHidden = true
                self.retakeattendancebtnoutlet.setTitle("Take Attendance", for: .normal)
            }
        })
        
      
      
        
        // Do any additional setup after loading the view.
    }
    
    
    
  func setupfont()
        {
            headertitle.font = headertitle.font?.withSize(Dataservices.ds.largefontsize)
            attendancestatus.font = attendancestatus.font?.withSize(Dataservices.ds.midfontsize)
            collectionheader.font = collectionheader.font?.withSize(Dataservices.ds.smallfontsize)
            
  
            collectiondone.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
            collectioncancel.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
            
            
            day.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
            month.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
            year.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
            editattendancebtnoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
            retakeattendancebtnoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
            
        }
    
    
    
    @IBAction func datepressed(_ sender: UIButton) {
        collectionviewshown = "days"
        self.collection.reloadData()
        self.collectionouterview.isHidden = false
    }
    
    
    @IBAction func monthpressed(_ sender: UIButton) {
        collectionviewshown = "months"
         self.collection.reloadData()
        self.collectionouterview.isHidden = false
    }
    
    
    @IBAction func yearpressed(_ sender: UIButton) {
        collectionviewshown = "years"
         self.collection.reloadData()
        self.collectionouterview.isHidden = false
    }
    
    
    @IBAction func editattendancepressed(_ sender: UIButton) {
        performSegue(withIdentifier: "taketoeditattendance", sender: nil)
    }
    
    
    
    @IBAction func retakeattendancepressed(_ sender: UIButton) {
        performSegue(withIdentifier: "gotoindividualstudents", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var dateint =  Int(self.day.titleLabel?.text ?? "")
        var yearint = Int(self.year.titleLabel?.text ?? "")
        
        if let seg = segue.destination as? TakeAttendanceViewController {
           seg.pc = self.pc
         
            if let d = dateint , let m = findmonth(x:self.month.titleLabel?.text ?? "") as? Int, let y = yearint
            {
               
                var cdate = DateCustom.from(year: y, month: m, day: d)
               var fulldate = "\(daypart)\(monthpart)\(yearpart)"
                seg.passeddate = fulldate
                seg.passedday = daypart
                seg.passedmonth = monthpart
                seg.passedyear = yearpart
            }
            else
            {
                seg.passeddate = "\(Date())"
            }
        }
        
        
        else if let seg = segue.destination as? EditAttendanceViewController {
            seg.pc = self.pc
            if let d = dateint , let m = findmonth(x:self.month.titleLabel?.text ?? "") as? Int, let y = yearint
            {
                
                var cdate = DateCustom.from(year: y, month: m, day: d)
                var fulldate = "\(daypart)\(monthpart)\(yearpart)"
                seg.passeddate = fulldate
                seg.passedday = daypart
                seg.passedmonth = monthpart
                seg.passedyear = yearpart
            }
            else
            {
                seg.passeddate = "\(Date())"
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
            yearpart = String(datearray[0])
            monthpart = String(datearray[1])
            daypart = String(datearray[2])
            self.day.titleLabel?.text = daypart
            self.month.titleLabel?.text = monthpart
            self.year.titleLabel?.text = yearpart
            
        }
        
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        
        
        var width : CGFloat?
        var height : CGFloat?
        if collectionviewshown == "days"
        {
            width = self.collection.frame.size.width/3
        }
        else
        {
            width = self.collection.frame.size.width/2
        }
        
        if collectionviewshown == "days"
        {
            height = self.collection.frame.size.height/10
        }
        else if collectionviewshown == "months"
        {
            height = self.collection.frame.size.height/6
        }
        else
        {
             height = self.collection.frame.size.height/6
        }
        
        if let w = width as? CGFloat , let h = height as? CGFloat {
          
            return CGSize(width: w, height:h)
        }
        else {
            return CGSize(width: 20, height:20)
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionviewshown == "days" {
            guard var mk = Int(monthpart) else { return 0 }
           
            return daysinmonth[mk]
            
        }
        else if collectionviewshown == "months" {
            return 12
        }
        else
        {
            return 10
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
        if indexPath != currentlyselectedrow {
            collectionView.cellForItem(at: currentlyselectedrow)?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
       
            currentlyselectedrow = indexPath
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath != currentlyselectedrow {
        collectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
        }
    }
    
   var currentlyselectedrow = IndexPath(row: 0, section: 0)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "teachervcdays", for: indexPath) as? TakeAttendanceTeacherVCCollectionViewCell {
        
           
            var active = false
            if collectionviewshown == "days" {
                var xe = indexPath.row + 1
               
                if "\(xe)" == daypart {
                    active = true
                    currentlyselectedrow = indexPath
                }
                cell.updatecell(x: "\(xe)",y:active)
                
                return cell
            }
            else if collectionviewshown == "months" {
                var xe = allmonths[indexPath.row]
                if xe == monthpart {
                    active = true
                    currentlyselectedrow = indexPath
                }
                cell.updatecell(x: allmonths[indexPath.row],y:active)
                
                return cell
            }
            else
            {
                var xe = (Int(yearpart) ?? 2019) - indexPath.row
                if "\(xe)" == yearpart {
                    active = true
                    currentlyselectedrow = indexPath
                }
                cell.updatecell(x: "\(xe)",y:active)
                
                return cell
            }
            
        }
        
        
       
        
        
        return UICollectionViewCell()
    }
    
   
   
    
    
    @IBAction func collectiondonepressed(_ sender: Any) {
        if collectionviewshown == "days" {
            daypart = "\(currentlyselectedrow.row + 1)"
            if(currentlyselectedrow.row + 1 >= 1 && currentlyselectedrow.row + 1 <= 9){
                daypart = "0\(daypart)"
            }
            self.day.titleLabel?.text = daypart
             self.day.setTitle(daypart, for: .normal)
            self.collectionouterview.isHidden = true
        }
        else if collectionviewshown == "months" {
            monthpart = "\(currentlyselectedrow.row + 1)"
            if(currentlyselectedrow.row + 1 >= 1 && currentlyselectedrow.row + 1 <= 9){
                monthpart = "0\(monthpart)"
            }
            self.month.titleLabel?.text = monthpart
             self.month.setTitle(monthpart, for: .normal)
            self.collectionouterview.isHidden = true
        }
        else
        {
            yearpart = (collection.cellForItem(at: currentlyselectedrow) as? TakeAttendanceTeacherVCCollectionViewCell)?.lab.text ?? ""
            self.year.titleLabel?.text = yearpart
            self.year.setTitle(yearpart, for: .normal)
            self.collectionouterview.isHidden = true
        }
        
        var fulldate = "\(daypart)\(monthpart)\(yearpart)"
        print("full date is \(fulldate)")
        
        checkforattendance(x:fulldate, status: { (success) -> Void in
            if(success)
            {
                self.attendancestatus.text = "Attendance Already Taken."
                self.editattendancebtnoutlet.isHidden = false
                self.retakeattendancebtnoutlet.setTitle("Re-Take Attendance", for: .normal)
            }
            else
            {
                self.attendancestatus.text = "Attendance Not Taken Yet."
                self.editattendancebtnoutlet.isHidden = true
                self.retakeattendancebtnoutlet.setTitle("Take Attendance", for: .normal)
            }
        })
       
    }
    
    
    @IBAction func collectioncancelpressed(_ sender: UIButton) {
        self.collectionouterview.isHidden = true
    }
    
    
     typealias fetcheddata = (_ success:Bool) -> Void
    func checkforattendance(x:String,status : @escaping fetcheddata)
    {
       
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        
        
        FIRDatabase.database().reference().child("attendance").child(t).child(s).child(pc?.code ?? "").child(self.yearpart).child(self.monthpart).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild(x)
                {
                    print("Exist")
                    status(true)
                }
                else
                {
                    print("Does not Exist")
                    status(false)
                }
            }
        
    }
    

}
