//
//  AttendanceViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/11/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AttendanceViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var yearlabel: UILabel!
    
    @IBOutlet weak var yeartextfield: UITextField!
    
    
    @IBOutlet weak var yearprevbtn: RoundedButton!
    
    
    @IBOutlet weak var yearnextbtn: RoundedButton!
    
    
    
    @IBOutlet weak var monthlabel: UILabel!
    
    @IBOutlet weak var monthtextfield: UITextField!
    
    
    @IBOutlet weak var monthprevbtn: RoundedButton!
    
    @IBOutlet weak var monthnextbtn: RoundedButton!
    
    
    @IBOutlet weak var closebtn: UIButton!
    
    
    @IBOutlet weak var changedateview: CustomView!
    
    
    
    @IBOutlet weak var upperviewhieght: NSLayoutConstraint!
    
    
    @IBOutlet weak var loader: CircularAttendanceLoader!
    
    
    @IBOutlet weak var loaderwidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var loaderheight: NSLayoutConstraint!
    
    
    @IBOutlet weak var changedatebtn: RoundedButton!
    
    
    
    @IBOutlet weak var header: UILabel!
    
    
    @IBOutlet weak var prevmonthoutlet: UIButton!
    
    @IBOutlet weak var nextmonthoutlet: UIButton!
    
    @IBOutlet weak var monthname: UILabel!
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    @IBOutlet weak var messagebtn: UIButton!
    
    
    var currentmonth = "jan"
    var currentyear = "2019"
    var y = "2019"
    var m = "jan"
    var monthslist = ["jan","feb","mar","apr","may","june","july","aug","sep","oct","nov","dec"]
    var days = ["jan":31,"feb":28,"mar":31,"apr":30,"may":31,"june":30,"july":31,"aug":31,"sep":30,"oct":31,"nov":30,"dec":31]
    
    var attendance:[attendancestruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.delegate = self
        self.collection.dataSource = self
        self.changedateview.isHidden = true
        self.yeartextfield.isEnabled =  false
        self.monthtextfield.isEnabled = false
        
        setupcurrenttime()
        
        self.monthname.text = "\(self.currentmonth.uppercased()) \(self.currentyear)"
        self.yeartextfield.text = "\(self.currentyear)"
        self.monthtextfield.text = self.currentmonth.capitalized
        
    self.upperviewhieght.constant = self.view.frame.size.height/4
        header.font = header.font.withSize(Dataservices.ds.largefontsize)
        monthname.font = monthname.font.withSize(Dataservices.ds.midfontsize)
        
        
        yearlabel.font = yearlabel.font.withSize(Dataservices.ds.smallfontsize)
        monthlabel.font = monthlabel.font.withSize(Dataservices.ds.smallfontsize)
        
        yeartextfield.font = yeartextfield.font?.withSize(Dataservices.ds.smallfontsize)
        monthtextfield.font = monthtextfield.font?.withSize(Dataservices.ds.smallfontsize)
        
        
    self.loaderwidth.constant = self.view.frame.size.width / 3
        self.loaderheight.constant = self.view.frame.size.width / 3
        
        prevmonthoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        nextmonthoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        closebtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        yearprevbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        yearnextbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        monthprevbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        monthnextbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        fetchdata( status: { (success) -> Void in
            self.attendance = self.attendance.sorted(by: { $0.date < $1.date })
            if(success)
            {
                self.collection.reloadData()
            }
            else
            {
                print("----------------------------------------Got False")
            }
        })

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func backbtnpressed(_ sender: UIButton) {
    }
    
    
    @IBAction func messagebtnpressed(_ sender: UIButton) {
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.attendance.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "attcell", for: indexPath) as? AttendanceCollectionViewCell
        {
            cell.updatecell(n:self.attendance[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
          return CGSize(width: 60, height: 60)
        
    }
    typealias fetcheddata = (_ success:Bool) -> Void
    func fetchdata(status : @escaping fetcheddata)
    {
        
        self.loader.setProgress(to: Double(0), withAnimation: true)
        attendance = []
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var t = KeychainWrapper.standard.string(forKey: "client")!
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
       print(currentmonth)
        if let x = monthslist.index(of: currentmonth.lowercased()) {
            var xx = x + 1
            var yy = ""
            if xx < 10 {
                yy = "0\(xx)"
            }
            else
            {
                yy = "\(xx)"
            }
            print(yy)
            print(self.currentyear)
            FIRDatabase.database().reference().child("students").child(t).child(s).child("attendance").child("\(self.currentyear)").child(yy).observeSingleEvent(of: .value) { (sse) in
                if let g = sse.value as? Dictionary<String,String>
                {
                    if g == nil
                    {
                        print("No values Found $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
                    }
                    var p = 0
                    var a = 0
                    for day in g
                    {
                        if day.value == "p" {
                            p = p + 1
                        }
                        else if day.value == "a" {
                            a = a + 1
                        }
                        var kj = attendancestruct(date: day.key, status: day.value)
                        self.attendance.append(kj)
                        
                    }
                    if self.attendance.count > 0
                    {
                        self.monthname.text = "\(self.currentmonth.uppercased()) \(self.currentyear)"
                        
                        
                    
                        self.loader.safePercent = (p+a)
                        
                        
                        self.loader.labelSize = 30
                        
                        var percentage  = Double(p) / Double(p + a)
                        
                        self.loader.setProgress(to: Double(percentage), withAnimation: true)
                        
                        
                        
                        
                        status(true)
                    }
                    else
                    {
                        
                    }
                    
                    
                    
                }
                else
                {
                    print("No value found")
            self.monthname.text = "No Attendance Available for the month \(self.currentmonth.uppercased())  \(self.currentyear)"
                    self.collection.reloadData()
                    status(false)
                }
            }
        }
        
       
        
    }
    
    
    
    @IBAction func closechnagedateviewpressed(_ sender: Any) {
        self.changedateview.isHidden = true
    }
    
    
    @IBAction func donebtnpressed(_ sender: Any) {
        self.currentyear = self.yeartextfield.text!
        self.currentmonth = self.monthtextfield.text!
        
        fetchdata( status: { (success) -> Void in
            self.attendance = self.attendance.sorted(by: { $0.date < $1.date })
            if(success)
            {
                self.collection.reloadData()
                self.changedateview.isHidden = true
            }
            else
            {
                print("----------------------------------------Got False")
                self.changedateview.isHidden = true
            }
        })
    }
    
    @IBAction func yearprevpressed(_ sender: Any) {
        if let x = self.yeartextfield.text as? String {
            var y = Int(x) ?? -1
            if y != -1 {
                y = y - 1
                self.yeartextfield.text = "\(y)"
            }
            
        }
    }
    
    
    @IBAction func yearnextpressed(_ sender: Any) {
        if let x = self.yeartextfield.text as? String {
            var y = Int(x) ?? -1
            if y != -1 {
                y = y + 1
                self.yeartextfield.text = "\(y)"
            }
            
        }
    }
    
    
    @IBAction func monthprevpressed(_ sender: Any) {
        if let x = self.monthtextfield.text?.lowercased() as? String {
            var i = self.monthslist.index(of: x)
            if i == 0 {
                i = 11
            }
            else
            {
                i = i! - 1
            }
            self.monthtextfield.text = self.monthslist[i!].capitalized
        }
    }
    
    
    @IBAction func monthnextpressed(_ sender: Any) {
        if let x = self.monthtextfield.text?.lowercased() as? String {
            var i = self.monthslist.index(of: x)
            if i == 11 {
                i = 0
            }
            else
            {
                i = i! + 1
            }
            self.monthtextfield.text = self.monthslist[i!].capitalized
        }
    }
    
    
    
    
    
    @IBAction func changedatebtnpressed(_ sender: RoundedButton) {
        
        self.changedateview.isHidden = false
    }
    
    
    func setupcurrenttime()
    {
        var x = Date()
        var strpd = x.description.split(separator: " ")
        var each = strpd.first!
        var datearray = each.split(separator: "-")
        print("Set up current time \(datearray)")
        print(datearray.count)
        if datearray.count == 3 {
            self.currentmonth = self.monthslist[Int(String(datearray[1]))! - 1]
            self.currentyear = (String(datearray[0]))
           
            
        }
        
    }
    
    
    
    @IBAction func prevmonthtapped(_ sender: UIButton) {
        var x = monthslist.index(of: currentmonth) 
        if x == 0
        {
            x = 11
            self.currentyear = "\(Int(self.currentyear)! - 1)"
        }
        else
        {
            x = (x ?? 1)  - 1
        }
            currentmonth = monthslist[x ?? 0]
            self.m = self.currentmonth
             self.monthname.text = self.m.uppercased()
            fetchdata( status: { (success) -> Void in
                self.attendance = self.attendance.sorted(by: { $0.date < $1.date })
                if(success)
                {
                    self.collection.reloadData()
                }
                else
                {
                    print("----------------------------------------Got False")
                }
            })
            
            
        
    }
    
    
    
    
    @IBAction func nextmonthtapped(_ sender: UIButton) {
        var x = monthslist.index(of: currentmonth)
        if x == 11
        {
            x = 0
            self.currentyear = "\(Int(self.currentyear)! + 1)"
        }
        else
        {
            x = (x ?? 1)  + 1
        }
            currentmonth = monthslist[x ?? 0]
            self.m = self.currentmonth
             self.monthname.text = self.m.uppercased()
            fetchdata( status: { (success) -> Void in
                self.attendance = self.attendance.sorted(by: { $0.date < $1.date })
                if(success)
                {
                    self.collection.reloadData()
                }
                else
                {
                    print("----------------------------------------Got False")
                }
            })
            
            
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
