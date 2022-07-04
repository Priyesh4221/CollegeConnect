//
//  StatictimetablescreentwoViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 10/29/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class StatictimetablescreentwoViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var popup: CustomView!
    
    var currentselectedperiod = ""
    var currentselectedsubject = ""
    var isnewclassadded = false
    
    var statictimetabledata = [statictimetable]()
    
    @IBOutlet weak var classcode: UILabel!
    
    var currentselectday = "monday"
    var noofperiods = 0
    
     var currentselectedclass = "clbbasec2"
    var currentselectedclasscode = "clbbasec2"
    
    
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var periodfield: CustomTextField!
    
    
    @IBOutlet weak var subjectfield: CustomTextField!
    
    
    @IBOutlet weak var addnewbtn: UIButton!
    
    @IBOutlet weak var closepopup: UIButton!
    
    
    @IBOutlet weak var popupperiodlabel: UILabel!
    
    
    @IBOutlet weak var popupsubjectlabel: UILabel!
    
    
    @IBOutlet weak var updateclassbtn: RoundedButton!
    
    @IBOutlet weak var deleteclassbtn: RoundedButton!
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upperviewheight.constant = self.view.frame.size.height/3
        self.periodfield.isEnabled =  false
        self.table.delegate = self
        self.table.dataSource =  self
        print("One")
        setupfont()
        getnoofperiods { (answer) in
            print("Hello  ")
            self.popup.isHidden = true
            self.classcode.text = self.currentselectedclass
            self.day.text = self.currentselectday.capitalized
            self.statictimetabledata.sort {
                $0.period < $1.period
            }
            self.table.reloadData()
            print("Two")
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    func setupfont()
    {
       periodfield.font = periodfield.font?.withSize(Dataservices.ds.smallfontsize)
       subjectfield.font = subjectfield.font?.withSize(Dataservices.ds.smallfontsize)
        classcode.font = classcode.font?.withSize(Dataservices.ds.largefontsize)
        day.font = day.font?.withSize(Dataservices.ds.midfontsize)
        popupperiodlabel.font = classcode.font?.withSize(Dataservices.ds.largefontsize)
        popupsubjectlabel.font = day.font?.withSize(Dataservices.ds.midfontsize)
        addnewbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        closepopup.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        updateclassbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        deleteclassbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
    }
    
    
    typealias progress = (_ success : Bool) -> Void
    func getnoofperiods(x:@escaping progress)
    {
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var t = KeychainWrapper.standard.string(forKey: "client")!
   
      print("Threee")
        print(currentselectedclass)
        print(self.currentselectday.lowercased())
       print(s)
        print(t)
        FIRDatabase.database().reference().child("timetable").child(t).child(currentselectedclass).child(self.currentselectday.lowercased()).observeSingleEvent(of: .value) { (snapshot) in
            print("Got in ----------------------------")
            let count = snapshot.childrenCount
            self.noofperiods = Int(count)
            print(self.noofperiods)
            if let snap = snapshot.value as? Dictionary<String,String> {
                
                for day in snap
                {
                    var k = (day.key.last)!
                    
                    print("\(k) \(day.value)")
                    var x  = statictimetable(period: "\(k)", subject: day.value)
                    self.statictimetabledata.append(x)
                }
                
                x(true)
            }
            else
            {
                x(false)
            }
        }
        
    }
    
    
    @IBAction func addnewclasstapped(_ sender: UIButton) {
        self.currentselectedperiod = ""
        self.currentselectedclass = ""
        self.periodfield.isEnabled = true
        UIView.animate(withDuration: 100) {
            self.periodfield.text = self.currentselectedperiod
            self.subjectfield.text = self.currentselectedclass
            self.popup.isHidden = false
        }
    }
    
    
    
    
    
    
    @IBAction func closepopup(_ sender: UIButton) {
        UIView.animate(withDuration: 100) {
            self.popup.isHidden = true
        }
    }
    
    func updateclass(p : String,s :String)
    {
        if (s != self.subjectfield.text || self.periodfield.isEnabled == true) {
                var t = KeychainWrapper.standard.string(forKey: "client")!
                print(t)
                print(currentselectedclasscode)
                print(self.currentselectday.lowercased())
                print("k\(p)")
                print(self.periodfield.text)
            
            

            
            FIRDatabase.database().reference().child("timetable").child(t).child(currentselectedclasscode).child(self.currentselectday.lowercased()).child("k\(p)").setValue(self.subjectfield.text!) { (err, ref) in
                    if err == nil {
                        self.popup.isHidden = true
                      var k =   Dataservices.ds.showalert(head: "Class updated", title: "\(s) has been assigned for period number \(p)", btntitle: "ok")
                        self.present(k, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        var k =   Dataservices.ds.showalert(head: "Class could not updated", title: "\(err?.localizedDescription)", btntitle: "ok")
                        self.present(k, animated: true, completion: nil)
                    }
                }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentselectedclass = self.statictimetabledata[indexPath.row].subject
        self.currentselectedperiod = self.statictimetabledata[indexPath.row].period
        self.periodfield.text = self.currentselectedperiod
        self.periodfield.isEnabled = false
        self.subjectfield.text = self.currentselectedclass
        UIView.animate(withDuration: 100) {
            self.popup.isHidden = false
        }
    }
    
    
    
    @IBAction func updateclasstapped(_ sender: RoundedButton) {
        if(self.periodfield.text == "" || self.subjectfield.text == ""){
            var k = Dataservices.ds.showalert(head: "Missing either of the value", title: "Either of period or subject can not be blank.", btntitle: "Ok")
             present(k, animated: true, completion: nil)
        }
        else
        {
            self.currentselectedperiod = self.periodfield.text!
            self.currentselectedsubject = self.subjectfield.text!
            self.currentselectedclass = self.subjectfield.text!
            print("Passing \(self.currentselectedperiod) and \(self.currentselectedsubject)")
            var alreadyperiodexist = false
            for each in self.statictimetabledata {
                print(each.period)
                print(self.periodfield.text)
                if each.period == self.periodfield.text {
                    alreadyperiodexist = true
                    break
                }
            }
            if(alreadyperiodexist == false) {
                updateclass(p: self.currentselectedperiod, s: self.currentselectedclass)
            }
            else
            {
                var k = Dataservices.ds.showalert(head: "Period \(self.periodfield.text!) already exist.", title: "You can not add class to an existing period , incase if you still want to add, kindly delete the existing class with same period and try again.", btntitle: "Ok")
                present(k, animated: true, completion: nil)
            }
            
        }
    }
    
    
    @IBAction func deleteclasstapped(_ sender: RoundedButton) {
        var t = KeychainWrapper.standard.string(forKey: "client")!
        
        
        let actionSheetController = UIAlertController (title: "Confirm Deleting Class", message: "Are you sure you want to delete this class ?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //Add Cancel-Action
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Add Save-Action
        actionSheetController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
            FIRDatabase.database().reference().child("timetable").child(t).child(self.currentselectedclasscode).child(self.currentselectday.lowercased()).child("k\(self.currentselectedperiod)").removeValue { (err, ref) in
                    if(err == nil)
                    {
                        
                        self.popup.isHidden = true
                        var k=0
                        for e in self.statictimetabledata {
                            if e.period == "k\(self.currentselectedperiod)" {
                                self.statictimetabledata.remove(at:k)
                                self.table.reloadData()
                            }
                            k=k+1
                        }
                        
                        
                    }
                }
            
        }))
        present(actionSheetController, animated: true, completion: nil)

    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statictimetabledata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "statictimetabletwo", for: indexPath) as? StatictimetablescreentwoTableViewCell {
            cell.updatecell(x: self.statictimetabledata[indexPath.row].period, y: self.statictimetabledata[indexPath.row].subject)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 7
    }
    

}
