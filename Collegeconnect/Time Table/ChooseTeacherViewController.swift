//
//  ChooseTeacherViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/30/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ChooseTeacherViewController: UIViewController , UITableViewDelegate,UITableViewDataSource {
   
    var passedteacherid = ""
    var passedclassid = ""
    var daypart = ""
    var monthpart = ""
    var yearpart = ""
    
    var mode = ""
    var classid  = ""
    
    @IBOutlet weak var footerview: UIView!
    
    @IBOutlet weak var footerviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var footerviewselectedteacher: UILabel!
    
    @IBOutlet weak var tablebottom: NSLayoutConstraint!
     var tappedclass : timetablevariable?
    var teachers :[teacherstruct] = []
    
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var chooseteachertop: NSLayoutConstraint!
    
    @IBOutlet weak var table: UITableView!
    

    var currentselectedteacher = "none"
    var currentselectedteacherid = ""
    
    
    
    @IBOutlet weak var chooseteacherlabel: UILabel!
    
    @IBOutlet weak var cancelbtn: UIButton!
    
    
    @IBOutlet weak var donebtn: UIButton!
    
    
    @IBOutlet weak var currentlyselectedlabel: UILabel!
    
    @IBOutlet weak var footerlabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upperviewheight.constant = self.view.frame.height/4
        chooseteachertop.constant = self.view.frame.height/4 * 0.6
        self.table.delegate = self
        self.table.dataSource = self
        self.currentselectedteacherid = self.passedteacherid
        setupfont()
         var s = KeychainWrapper.standard.string(forKey: "auth")!
        s = "teacher123"
        if self.view.frame.size.height/8 > 84 {
        self.footerviewheight.constant = self.view.frame.size.height/8
            self.tablebottom.constant = self.view.frame.size.height/8
        }
        self.footerviewselectedteacher.text = self.currentselectedteacher.capitalized
        fetchteacherdetails { (got) in
            if got {

                var si = 0
                while si < self.teachers.count {
                    if self.teachers[si].id == s {
                        self.teachers.swapAt(si, 0)
                    }
                    si = si + 1
                }
                self.table.reloadData()
                print("Hello \(self.teachers.count)")
            }
            else
            {

            }
        }
        // Do any additional setup after loading the view.
    }
    

    
    
    
    func setupfont()
    {
        chooseteacherlabel.font = chooseteacherlabel.font?.withSize(Dataservices.ds.largefontsize)
        
        currentlyselectedlabel.font = currentlyselectedlabel.font?.withSize(Dataservices.ds.midfontsize)
        footerlabel.font = footerlabel.font?.withSize(Dataservices.ds.midfontsize)
        
        
        
        
        cancelbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        donebtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        
        
    }
    
    
    @IBAction func cancelpressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func donepressed(_ sender: UIButton) {
        
        
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        if self.mode == "add" {
            
            
            FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).child(self.classid).child("takenby").setValue(self.currentselectedteacherid) { (err, ref) in
                if err == nil {
                    self.dismiss(animated: true) {

                    }
                
                }
                else {
                    print(err.debugDescription)
                   
                    
                }
            }
            
        }
        else
        {
            updateteacher { (success) in
                if success {
                     self.dismiss(animated: true, completion: nil)
                }
            }
            
            self.dismiss(animated: true) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ChangeTimeTableViewController") as! ChangeTimeTableViewController
                controller.selectedteacherid = self.currentselectedteacherid
                print("Did set is as \(self.currentselectedteacherid)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chooseteachercell", for: indexPath) as? ChooseTeacherTableViewCell {
            cell.selectionStyle = .none
            if self.teachers[indexPath.row].id == self.passedteacherid {
                cell.status.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
                cell.setSelected(true, animated:true)
                self.footerviewselectedteacher.text = self.teachers[indexPath.row].name.capitalized
                self.currentselectedteacher = self.teachers[indexPath.row].name.capitalized
            }
            cell.setupcell(x: self.teachers[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.table.frame.size.height/5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = table.cellForRow(at: indexPath) as? ChooseTeacherTableViewCell {
            cell.status.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6470588235, blue: 0.8705882353, alpha: 1)
            self.currentselectedteacher = cell.name.text!
            self.footerviewselectedteacher.text = self.currentselectedteacher.capitalized
            if let kc = table.cellForRow(at: indexPath) as? ChooseTeacherTableViewCell {
                self.currentselectedteacher = self.teachers[indexPath.row].name
                self.currentselectedteacherid = self.teachers[indexPath.row].id
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = table.cellForRow(at: indexPath) as? ChooseTeacherTableViewCell {
            cell.status.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
            self.currentselectedteacher = "none"
            self.footerviewselectedteacher.text = self.currentselectedteacher.capitalized
        }
    }
    
    
    
    typealias progress = (_ success : Bool) -> Void
    func fetchteacherdetails(x:@escaping progress) {
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        FIRDatabase.database().reference().child("teachers").child(t).observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? Dictionary<String, AnyObject> {
                for teacher in snap {
                    var name = ""
                    var id = "\(teacher.key)"
                    var profileimage = ""
                    if let details = teacher.value as? Dictionary<String,AnyObject> {
                        if let n = details["name"] as? String {
                            name = n
                        }
                        if let p = details["profileimage"] as? String {
                            profileimage = p
                        }
                    }
                    var m = teacherstruct(id: id, name: name, profileimage: profileimage)
                    self.teachers.append(m)
                }
                x(true)
            }
            else {
                
                x(false)
            }
        }
    }
    
    
   
    func updateteacher(y:@escaping progress)
    {
        print(self.tappedclass!.classnumber)
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).child(self.tappedclass!.classnumber).child("takenby").setValue(self.currentselectedteacherid) { (err, ref) in
            if err == nil {
                self.dismiss(animated: true) {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "ChangeTimeTableViewController") as! ChangeTimeTableViewController
                    controller.selectedteacherid = self.currentselectedteacherid
                }
                y(true)
            }
            else {
                print(err.debugDescription)
               y(false)
                
            }
        }
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? ChangeTimeTableViewController {
            if self.mode == "add"
            {
                seg.selectedteacherid = self.currentselectedteacherid
            }
            seg.selectedteacherid = self.currentselectedteacherid
        }
    }
    
    
    
    
    
    

}
