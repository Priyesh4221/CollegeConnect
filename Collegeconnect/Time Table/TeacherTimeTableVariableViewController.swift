//
//  TeacherTimeTableVariableViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/23/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase


class TeacherTimeTableVariableViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    
    @IBOutlet weak var messagebtn: UIButton!
    
    
    
    
    
   var isnewclass = false
    var classtapped : timetablevariable?
    
    var passedclasscode = ""

    @IBOutlet weak var stackviewbottom: NSLayoutConstraint!
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    
    @IBOutlet weak var noclassesviewtopspace: NSLayoutConstraint!
    
    
    @IBOutlet weak var noclassesviewbottomspace: NSLayoutConstraint!
    
    
    @IBOutlet weak var noclassesavaialble: CustomView!
    
    
    
    @IBOutlet weak var daybtnoutlet: UIButton!
    
    @IBOutlet weak var monthbtnoutlet: UIButton!
    
    @IBOutlet weak var yearbtnoutlet: UIButton!
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var addclassbtn: UIButton!
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    
    @IBOutlet weak var collectionouterview: UIView!
    
    
    @IBOutlet weak var upperlabeltimetable: UILabel!
    
    
    @IBOutlet weak var warning: UILabel!
    
    @IBOutlet weak var donedatepicking: UIButton!
    
    
    @IBOutlet weak var canceldatepicking: UIButton!
    @IBOutlet weak var choosedate: UILabel!
    
    
    var  alldaysdata : [timetablevariableholder]?
    var eachdaydata : [timetablevariable]?
    var alldaysclasses : Dictionary<String,Int> = ["":0]
    var classestitle : Dictionary<String,[String]> = ["":[]]
    
    var yearpart = "2019"
    var monthpart = "08"
    var daypart = "24"
    var gyearpart = "2019"
    
    
    var daysinmonth = [0,31,28,31,30,31,30,31,31,30,31,30,31]
    var allmonths = ["January","February","March","April","May","June","July","August","September","October","Novermber","December"]
    
    var collectionviewshown = "days"
    var noofclasses = 0
    
    @IBOutlet weak var upperview: CustomView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackviewbottom.constant = self.upperview.frame.size.height/5
        self.upperviewheight.constant = self.view.frame.size.height/3
        self.noclassesviewtopspace.constant = self.view.frame.size.height/3
       
        self.table.delegate = self
        self.table.dataSource = self
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collectionouterview.isHidden = true
        setupcurrenttime()
        setupfont()

        var role = KeychainWrapper.standard.string(forKey: "role")!
        print("Check the role")
        print(role)
        if role == "teacher" || role == "admin" {
            self.addclassbtn.isHidden = false
        }
        else
        {
            self.addclassbtn.isHidden = true
        }
        print("Finally reached here")
        getnoofperiods { (success) in
            print(self.alldaysdata)
            if(success)
            {
                self.table.reloadData()

            }
        }

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backbtnpressed(_ sender: UIButton) {
    }
    
    @IBAction func messagebtnpressed(_ sender: UIButton) {
    }
    
    
    
    func setupfont()
    {
        upperlabeltimetable.font = upperlabeltimetable.font?.withSize(Dataservices.ds.largefontsize)
        
        warning.font = warning.font?.withSize(Dataservices.ds.midfontsize)
        choosedate.font = choosedate.font?.withSize(Dataservices.ds.midfontsize)
        

        
        donedatepicking.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        canceldatepicking.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)

    }
    
    
    override func viewWillLayoutSubviews() {
        print("will Layout Subviews")
    }
    override func viewDidLayoutSubviews() {
        print("Did layout subviews")
    }
    override func viewDidAppear(_ animated: Bool) {
        print("View Did appear")
    }
    
    @IBAction func daybtnclicked(_ sender: UIButton) {
        print("I entered in this")
        collectionviewshown = "days"
        self.collection.reloadData()
        self.collectionouterview.isHidden = false
    }
    
    
    
    @IBAction func monthbtnclicked(_ sender: UIButton) {
        collectionviewshown = "months"
        self.collection.reloadData()
        self.collectionouterview.isHidden = false
    }
    
    
    
    @IBAction func yearbtnclicked(_ sender: UIButton) {
        collectionviewshown = "years"
        self.collection.reloadData()
        self.collectionouterview.isHidden = false
    }
    
    
    
    
    @IBAction func cancelbtnpressed(_ sender: UIButton) {
        self.collectionouterview.isHidden = true
    }
    
    
    
    @IBAction func addnewclasstapped(_ sender: UIButton) {
        self.isnewclass = true
        performSegue(withIdentifier: "editthisclass", sender: nil)
    }
    
    
    
    
    
    @IBAction func donebtnpressed(_ sender: UIButton) {
        if collectionviewshown == "days" {
            daypart = "\(currentlyselectedrow.row + 1)"
            if(currentlyselectedrow.row + 1 >= 1 && currentlyselectedrow.row + 1 <= 9){
                daypart = "0\(daypart)"
            }
            self.daybtnoutlet.titleLabel?.text = daypart
            self.daybtnoutlet.setTitle(daypart, for: .normal)
            self.collectionouterview.isHidden = true
        }
        else if collectionviewshown == "months" {
            monthpart = "\(currentlyselectedrow.row + 1)"
            if(currentlyselectedrow.row + 1 >= 1 && currentlyselectedrow.row + 1 <= 9){
                monthpart = "0\(monthpart)"
            }
            self.monthbtnoutlet.titleLabel?.text = monthpart
            self.monthbtnoutlet.setTitle(monthpart, for: .normal)
            self.collectionouterview.isHidden = true
        }
        else
        {
            yearpart = "\((Int(gyearpart) ?? 2019) - (Int)(currentlyselectedrow.row))"
            self.yearbtnoutlet.titleLabel?.text = yearpart
            self.yearbtnoutlet.setTitle(yearpart, for: .normal)
            self.collectionouterview.isHidden = true
        }
        
        var fulldate = "\(daypart)\(monthpart)\(yearpart)"
        print("full date is \(fulldate)")
        
        getnoofperiods(x: { (x) -> Void in
            if(x)
            {
                self.table.reloadData()
            }
            else
            {
                self.table.reloadData()
            }
            
        })
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
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeachertimetableVariableCollectionViewCell", for: indexPath) as? TeachertimetableVariableCollectionViewCell {
            
            
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
                var xe = (Int(gyearpart) ?? 2019) - indexPath.row
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
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var count = 0
//       print("length of alldaysdata is \(self.alldaysdata?.count)")
//        for ee in alldaysdata ?? [] {
//            var x = ee.date
//            if let x = "\(self.yearpart)\(self.monthpart)\(self.daypart)" as? String {
//                print("The number of cells will be \(ee.contents.count)")
//                return ee.contents.count
//            }
//        }
        print("Each day data is \(self.eachdaydata?.count)")
        return self.eachdaydata?.count ?? 0
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "variabletimetablecell", for: indexPath) as? TeacherTimetablevariableTableViewCell {
         
          
            var defaultvalue = timetablevariable(classnumber: "", begins: "", ends: "", reminders: "", room: "", subject: "", teacherid: "", teachername: "")
            print("Copied this")
            
            cell.updatecell(x: (eachdaydata?[indexPath.row])!)
            return cell
//            for ee in alldaysdata ?? [] {
//                var x = ee.date
//                if let x = "\(self.yearpart)\(self.monthpart)\(self.daypart)" as? String {
//                    cell.updatecell(x: ee.contents[indexPath.row])
//                     return cell
//                    break
//                }
//            }
            
            
            
           
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.classtapped = (eachdaydata?[indexPath.row])!
        performSegue(withIdentifier: "editthisclass", sender: nil)
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
            gyearpart = yearpart
            self.daybtnoutlet.setTitle(daypart, for: .normal)
            self.monthbtnoutlet.setTitle(monthpart, for: .normal)
            self.yearbtnoutlet.setTitle(yearpart, for: .normal)
            
        }
        
    }
    
    typealias progress = (_ success : Bool) -> Void
    func getnoofperiods(x:@escaping progress)
    {
        print(self.passedclasscode)
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
       
        var c = self.passedclasscode
        FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).observeSingleEvent(of: .value) { (snapshot) in
            print("Got in ----------------------------")
            let count = snapshot.childrenCount
            self.noofclasses = Int(count)
            self.alldaysclasses["\(self.yearpart)\(self.monthpart)\(self.daypart)"] = Int(count)
            if Int(count) > 0 {
                self.noclassesavaialble.isHidden = true
            }
            else {
                self.noclassesavaialble.isHidden = false
            }
            print(self.noofclasses)
            var datekey  = "\(self.yearpart)\(self.monthpart)\(self.daypart)"
            self.eachdaydata = []
            if let snap = snapshot.value as? Dictionary<String,AnyObject> {
                
               
               
               
                for s in snap {
                    var begins = ""
                    var ends = ""
                    var reminders = ""
                    var room = ""
                    var subject = ""
                    var teacherid = ""
                    
                    if let b = s.value["begins"] as? String {
                        begins = b
                    }
                    if let e = s.value["ends"] as? String {
                        ends = e
                    }
                    if let r = s.value["reminders"] as? String {
                        reminders = r
                    }
                    if let ro = s.value["room"] as? String {
                        room = ro
                    }
                    if let su = s.value["subject"] as? String {
                        subject = su
                    }
                    if let t = s.value["takenby"] as? String {
                        teacherid = t
                    }
                    var xy = timetablevariable(classnumber: s.key, begins: begins, ends: ends, reminders: reminders, room: room, subject: subject, teacherid: teacherid, teachername: "")
                    
                    print("Appending \(s.key)")
                    var datekey  = "\(self.yearpart)\(self.monthpart)\(self.daypart)"
                    
                    self.eachdaydata?.append(xy)
                    print("Length is ")
                    print(self.eachdaydata?.count)
                    
                
                  
                    

                }
                
               
               
//                self.alldaysdata["\(self.yearpart)\(self.monthpart)\(self.daypart)"] = insideeachday
                self.alldaysclasses["\(self.yearpart)\(self.monthpart)\(self.daypart)"] = Int(count)
                
                
                x(true)
            }
            else
            {
                x(false)
            }
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? ChangeTimeTableViewController {
            if segue.identifier == "editthisclass" {
                print("hey")
                print(self.isnewclass)
                if self.isnewclass == false {
                    if let tc = self.classtapped as? timetablevariable {
                        seg.tappedclass = self.classtapped
                        seg.daypart = self.daypart
                        seg.monthpart = self.monthpart
                        seg.yearpart = self.yearpart
                    }
                }
                else
                {
                    var nc = timetablevariable(classnumber: "", begins: "", ends: "", reminders: "", room: "", subject: "", teacherid: "", teachername: "")
                    seg.daypart = self.daypart
                    seg.monthpart = self.monthpart
                    seg.yearpart = self.yearpart
                    seg.tappedclass = nc
                    seg.isnewclass = true
                }
            }
            
        }
    }

}

