//
//  ChangeTimeTableViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/27/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class ChangeTimeTableViewController: UIViewController {
    
    
    
    @IBOutlet weak var roomlabel: UILabel!
    
    @IBOutlet weak var subjectlabel: UILabel!
    
    
    @IBOutlet weak var beginsatlabel: UILabel!
    
    
    @IBOutlet weak var hhlabelbegins: UILabel!
    
    @IBOutlet weak var mmlabelbegins: UILabel!
    
    @IBOutlet weak var endsatlabel: UILabel!
    
    @IBOutlet weak var hhlabelends: UILabel!
    

    @IBOutlet weak var mmlabelends: UILabel!
    
    @IBOutlet weak var reminderslabel: UILabel!
    
    
    
    
    var tappedclass : timetablevariable?
    
    var isnewclass = false
    
    @IBOutlet weak var segmentwidth: NSLayoutConstraint!
    
    
    @IBOutlet weak var textarea: UITextView!
    @IBOutlet weak var segment2width: NSLayoutConstraint!
    
    
    @IBOutlet weak var updateclasslabel: UILabel!
    
    
    
    @IBOutlet weak var room: UITextField!
    
    
    @IBOutlet weak var subject: UITextField!
    
    
    
    
    @IBOutlet weak var changeteacherbtn: RoundedButton!
    
    
    @IBOutlet weak var cancelclassbtn: RoundedButton!
    
    
   
    
    @IBOutlet weak var beginsatamorpm: UISegmentedControl!
    
    
   
    @IBOutlet weak var beginsathh: UILabel!
    
    
    @IBOutlet weak var beginathh: UITextField!
    

    @IBOutlet weak var beginatmm: UITextField!
    
    
    @IBOutlet weak var endathh: UITextField!
    
    
    @IBOutlet weak var endatmm: UITextField!
    
    
    @IBOutlet weak var endsatamorpm: UISegmentedControl!
    
    
    @IBOutlet weak var reminders: UITextView!
    
    
    
    var daypart = ""
    var monthpart = ""
    var yearpart = ""
    
    var selectedteacherid = ""
    var newclassid = ""
    
    
    @IBOutlet weak var cancelbtn: UIButton!
    
    @IBOutlet weak var messagebtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        print("getting to show")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentwidth.constant = self.view.frame.width/3
        self.segment2width.constant = self.view.frame.width/3
        self.textarea.layer.cornerRadius = 10
        self.selectedteacherid = self.tappedclass?.teacherid ?? ""
        self.room.text = tappedclass?.room.uppercased()
        self.subject.text = tappedclass?.subject.capitalized
        self.reminders.text = tappedclass?.reminders.capitalized
        
        setupfont()
        if let t = tappedclass?.teacherid {
            self.selectedteacherid = tappedclass!.teacherid
        }
       
        
       
     
        
        if isnewclass == true {
            self.cancelclassbtn.isHidden = true
            self.changeteacherbtn.setTitle("Set Teacher", for: .normal)
            self.updateclasslabel.text = "Add New Class"
        }
        else
        {
            self.updateclasslabel.text = "Update Class"
        }
        
        var begsuffix = ""
        var endsuffix = ""
        var beghours = ""
        var begmins = ""
        var endhours = ""
        var endmins = ""
        
        if isnewclass == false
        {
                if let beg1 = tappedclass?.begins.split(separator: "a")
                {
                    print("enterinh")
                    print(beg1)
                    print(beg1[0])
                    if beg1.count == 2
                    {
                        begsuffix = "am"
                        var aheadpart = beg1[0].split(separator: ":")
                        print(aheadpart)
                        beghours = String(aheadpart[0])
                        begmins = String(aheadpart[1])
                    }
                
                    else if let bg1 = tappedclass?.begins.split(separator: "p")
                    {
                        print("enterinh")
                        begsuffix = "pm"
                        print(bg1)
                        print(bg1[0])
                            var aheadpart = bg1[0].split(separator: ":")
                            beghours = String(aheadpart[0])
                            begmins = String(aheadpart[1])
                        
                        
                    }
            }
            
        
                if let end1 = tappedclass?.ends.split(separator: "a")
                {
                    if end1.count == 2
                    {
                        endsuffix = "am"
                        var ahp = end1[0].split(separator: ":")
                        endhours = String(ahp[0])
                        endmins = String(ahp[1])
                    }
                
                    else if let ed1 = tappedclass?.ends.split(separator: "p")
                    {
                        endsuffix = "pm"
                        

                        
                            var ahp = ed1[0].split(separator: ":")
                            endhours = String(ahp[0])
                            endmins = String(ahp[1])
                        

                    }
            }
                
        
        
                if begsuffix == "am"
                {
                    beginsatamorpm.selectedSegmentIndex = 0
                }else
                {
                    beginsatamorpm.selectedSegmentIndex = 1
                }
        
                if endsuffix == "am"
                {
                    endsatamorpm.selectedSegmentIndex = 0
                }else
                {
                    endsatamorpm.selectedSegmentIndex = 1
                }
        }
        
        beginathh.text = beghours
        beginatmm.text = begmins
        endathh.text = endhours
        endatmm.text = endmins
        
    }
    
    func setupfont()
    {
        updateclasslabel.font = updateclasslabel.font?.withSize(Dataservices.ds.midfontsize)
                updateclasslabel.font = updateclasslabel.font?.withSize(Dataservices.ds.midfontsize)
        
    roomlabel.font = roomlabel.font?.withSize(Dataservices.ds.smallfontsize)
    subjectlabel.font = subjectlabel.font?.withSize(Dataservices.ds.smallfontsize)
    beginsatlabel.font = beginsatlabel.font?.withSize(Dataservices.ds.smallfontsize)
    hhlabelbegins.font = hhlabelbegins.font?.withSize(Dataservices.ds.smallfontsize)
    hhlabelends.font = hhlabelends.font?.withSize(Dataservices.ds.smallfontsize)
    mmlabelbegins.font = mmlabelbegins.font?.withSize(Dataservices.ds.smallfontsize)
    mmlabelends.font = mmlabelends.font?.withSize(Dataservices.ds.smallfontsize)
    endsatlabel.font = endsatlabel.font?.withSize(Dataservices.ds.smallfontsize)
    reminderslabel.font = reminderslabel.font?.withSize(Dataservices.ds.smallfontsize)
        
        
  
        
        
        
        room.font = room.font?.withSize(Dataservices.ds.smallfontsize)
        subject.font = subject.font?.withSize(Dataservices.ds.smallfontsize)
        beginathh.font = beginathh.font?.withSize(Dataservices.ds.smallfontsize)
        beginatmm.font = beginatmm.font?.withSize(Dataservices.ds.smallfontsize)
        endathh.font = endathh.font?.withSize(Dataservices.ds.smallfontsize)
        endatmm.font = endatmm.font?.withSize(Dataservices.ds.smallfontsize)
        reminders.font = reminders.font?.withSize(Dataservices.ds.smallfontsize)

        
        
        
        cancelbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        messagebtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        
        changeteacherbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        cancelclassbtn.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        
        
    }
    
    override func viewWillLayoutSubviews() {
        print("Hello ID \(self.selectedteacherid)")
    }
   
    @IBAction func canceltapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donetapped(_ sender: UIButton) {
        
        if isnewclass == false {
            let actionSheetController = UIAlertController (title: "Confirm Changes", message: "Are you sure you want to make these changes in the class ?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
            //Add Cancel-Action
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
            //Add Save-Action
            actionSheetController.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
                print("will set is as \(self.selectedteacherid)")
                self.lookforchanges()
                self.dismiss(animated: true, completion: nil)
                
                
            }))
            present(actionSheetController, animated: true, completion: nil)
        }
        else {
            
            let actionSheetController = UIAlertController (title: "Confirm Adding Class", message: "Are you sure you want to add new class for \(daypart)/\(monthpart)/\(yearpart) ?", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            //Add Cancel-Action
            actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            
            //Add Save-Action
            actionSheetController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
               
                var s = KeychainWrapper.standard.string(forKey: "auth")!
                var t = KeychainWrapper.standard.string(forKey: "school")!
                var c = KeychainWrapper.standard.string(forKey: "classcode")!
                FIRDatabase.database().reference().child("timetable").child(t).child(c).child(self.yearpart).child(self.monthpart).child(self.daypart).child(self.newclassid).child("takenby").observeSingleEvent(of: .value) { (snap) in
                    print("Hola YEah \(snap.value)")
                    if let sv = snap.value as? String {
                        self.selectedteacherid = sv
                    }
                    self.createnewclass()
                    self.dismiss(animated: true, completion: nil)
                    }

                
            }))
            present(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func changeteachertapped(_ sender: UIButton) {
        if(isnewclass == true)
        {
            var s = KeychainWrapper.standard.string(forKey: "auth")!
            var t = KeychainWrapper.standard.string(forKey: "school")!
            var c = KeychainWrapper.standard.string(forKey: "classcode")!
           
            var newclassvalues = ["takenby":""]
             self.newclassid =              FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).childByAutoId().key
                FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).child(self.newclassid).setValue(newclassvalues) { (err, ref) in
                
                if(err == nil)
                {
                    self.performSegue(withIdentifier: "changeteacher", sender: nil)
                }
                else {
                   self.performSegue(withIdentifier: "changeteacher", sender: nil)
                }
            }
        }
        else
        {
            performSegue(withIdentifier: "changeteacher", sender: nil)
        }
        
        print("New Key class \(self.newclassid)")
        
        
    }
    
    
    @IBAction func cancelclasstapped(_ sender: UIButton) {
        print("Cancelling Class \(self.tappedclass?.classnumber)")
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        
        let actionSheetController = UIAlertController (title: "Confirm Deleting Class", message: "Are you sure you want to delete this class ?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //Add Cancel-Action
        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        //Add Save-Action
        actionSheetController.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (actionSheetController) -> Void in
            if let key = self.tappedclass?.classnumber as? String { FIRDatabase.database().reference().child("timetable").child(t).child(c).child(self.yearpart).child(self.monthpart).child(self.daypart).child("\(key)").removeValue()
                self.dismiss(animated: true, completion: nil)
            }
            
        }))
        present(actionSheetController, animated: true, completion: nil)
        
       
        
    }
    
    @IBAction func beginsatampmchanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func endsatampmchanged(_ sender: UISegmentedControl) {
    }
    
    
    
    
    func createnewclass()
    {
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var t = KeychainWrapper.standard.string(forKey: "school")!
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        var room = self.room.text! ?? ""
        var subject = self.subject.text!
        var remainder = self.reminders.text!
        var teacherselectedid = self.selectedteacherid
        var beginsuffix = ""
        var endssuffix = ""
        if self.beginsatamorpm.selectedSegmentIndex == 0 {
            beginsuffix = "am"
        }
        else {
            beginsuffix = "pm"
        }
        if self.endsatamorpm.selectedSegmentIndex == 0 {
            endssuffix = "am"
        }
        else {
            endssuffix = "pm"
        }
        var begins  = "\(self.beginathh.text!):\(self.beginatmm.text!)\(beginsuffix)"
        var ends = "\(self.endathh.text!):\(self.endatmm.text!)\(endssuffix)"
        
        
        
        
        print(room)
        print(subject)
        print(remainder)
        print(teacherselectedid)
        print(begins)
        print(ends)
       

       
        
        if(self.newclassid == "")
        {
            self.newclassid = FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).childByAutoId().key
        }
        
        
        
        var newclassarray = ["begins":"\(begins)","ends":"\(ends)","reminders":"\(remainder)","room":"\(room)","subject":"\(subject)","takenby":"\(self.selectedteacherid)","updatedby":"\(s)","updatedat":"\(Date())"]
        
        
        
      
        
        
        
        
        FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).child(self.newclassid).setValue(newclassarray) { (err, ref) in

                if(err == nil)
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else {
                    let actionSheetController = UIAlertController (title: "Error Adding Class", message: "\(err?.localizedDescription)", preferredStyle: UIAlertControllerStyle.actionSheet)

                    //Add Cancel-Action
                    actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

                    self.present(actionSheetController, animated: true, completion: nil)
                }
            }
    }
    
    
    
    
    func lookforchanges()
    {
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var t = KeychainWrapper.standard.string(forKey: "school")!
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        var latestroomno = self.room.text!
        var latestsubject = self.subject.text!
        var latestbeginsamorpm = self.beginsatamorpm.selectedSegmentIndex == 0 ? "am" : "pm"
        var latestbeginsat = "\(self.beginathh.text!):\(self.beginatmm.text!)\(latestbeginsamorpm)"
        var latestendsamorpm = self.endsatamorpm.selectedSegmentIndex == 0 ? "am" : "pm"
        var latestendsat = "\(self.endathh.text!):\(self.endatmm.text!)\(latestendsamorpm)"
        var latestremainder = self.reminders.text!
        
        
        print(latestroomno)
        print(latestsubject)
        print(latestbeginsat)
        print(latestendsat)
        print(latestremainder)
        
        if latestroomno != self.tappedclass?.room || latestsubject != self.tappedclass?.subject || latestbeginsat != self.tappedclass?.begins || latestendsat != self.tappedclass?.ends || latestremainder != self.tappedclass?.reminders {
            var newx = timetablevariable(classnumber: self.tappedclass!.classnumber, begins: latestbeginsat, ends: latestendsat, reminders: latestremainder, room: latestroomno, subject: latestsubject, teacherid: self.tappedclass!.teacherid, teachername: "\(self.tappedclass!.teachername)")
            
            var newxarray = ["begins":"\(latestbeginsat)","ends":"\(latestendsat)","reminders":"\(latestremainder)","room":"\(latestroomno)","takenby":"\(self.selectedteacherid ?? "")","subject":"\(latestsubject)","updatedby":"\(s)","updatedat":"\(Date())"]
           
            if let key = self.tappedclass?.classnumber as? String { FIRDatabase.database().reference().child("timetable").child(t).child(c).child(yearpart).child(monthpart).child(daypart).child("\(key)").updateChildValues(newxarray) { (err, ref) in
                    if(err == nil)
                    {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else {
                        let actionSheetController = UIAlertController (title: "Error Adding Class", message: "\(err?.localizedDescription)", preferredStyle: UIAlertControllerStyle.actionSheet)
                        
                        //Add Cancel-Action
                        actionSheetController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        
                        self.present(actionSheetController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? ChooseTeacherViewController {
            if segue.identifier == "changeteacher" {
                seg.passedteacherid = self.tappedclass?.teacherid ?? ""
                seg.daypart = self.daypart
                seg.monthpart = self.monthpart
                seg.yearpart = self.yearpart
                seg.tappedclass = self.tappedclass
                if isnewclass == true {
                    seg.mode = "add"
                    seg.classid = self.newclassid
                }
                else
                {
                    seg.mode = "edit"
                }
            }
        }
    }

}
