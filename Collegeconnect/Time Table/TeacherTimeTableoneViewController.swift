//
//  TeacherTimeTableoneViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 8/20/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class TeacherTimeTableoneViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UITableViewDelegate , UITableViewDataSource{
 
    
   var passedclass = "clbbasec2"
    
    @IBOutlet weak var edittopspacing: NSLayoutConstraint!
    
    @IBOutlet weak var titletagtop: NSLayoutConstraint!
    
    @IBOutlet weak var collection: UICollectionView!
    
    
    @IBOutlet weak var table: UITableView!
    
    var noofperiods = 7
    
    
    @IBOutlet weak var editbuttonaccess: UIButton!
    
    @IBOutlet weak var timetablelabel: UILabel!
    
    @IBOutlet weak var heightofcustomview: NSLayoutConstraint!
    
    var alldaysdata : Dictionary<String,Dictionary<String,String>> = ["" : ["":""]]
    var alldaysperiods : Dictionary<String,Int> = ["":0]
    
    var daysname = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    var currentselectday = "Monday"
    override func viewDidLoad() {
        super.viewDidLoad()
 
        self.heightofcustomview.constant = self.view.frame.size.height/3

        self.edittopspacing.constant = (self.view.frame.size.height/3)/5
        self.collection.delegate = self
        self.collection.dataSource = self
        
        self.table.delegate = self
        self.table.dataSource = self
        setupfont()
        if(Dataservices.ds.role == "student" || Dataservices.ds.role == "parent") {
            self.editbuttonaccess.isHidden = true
        }
        else
        {
            checkwhetherallowedtoedit { (reply) in
                if(reply) {
                    self.editbuttonaccess.isHidden = false
                }
                else
                {
                    self.editbuttonaccess.isHidden = true
                }
            }
        }

        getnoofperiods { (answer) in
            print("Hello  ")
            print(self.alldaysdata["\(self.currentselectday.lowercased())"])
            self.table.reloadData()
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func editbtnpressed(_ sender: UIButton) {
        performSegue(withIdentifier: "editstatictable", sender: nil)
    }
    
    
    func setupfont()
    {
        timetablelabel.font = timetablelabel.font?.withSize(Dataservices.ds.largefontsize)
        
  
        
        
        
        editbuttonaccess.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)

        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "daynamecollectioncell", for: indexPath) as? TeacherTimeTableDay1CollectionViewCell {
            var ac = true
            if currentselectday == daysname[indexPath.row] {
                ac = true
            }
            else {
                ac = false
            }
            cell.update(x: daysname[indexPath.row], active : ac)
            return cell
        }
        return UICollectionViewCell()
    }
    
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let x = CGSize(width: self.view.frame.size.width/3.5, height: self.collection.frame.size.height)
        return x
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentselectday = daysname[indexPath.row]
        self.collection.reloadData()
        print("Checking for \(self.currentselectday.lowercased())")
        if(self.alldaysdata[self.currentselectday.lowercased()] == nil)
        {
            getnoofperiods { (answer) in
                print("Hello  ")
                print(self.alldaysdata["\(self.currentselectday.lowercased())"])
                self.table.reloadData()
            }
        }
        else
        {
            
            self.table.reloadData()
        }
    }
    
    typealias progress = (_ success : Bool) -> Void
    
    
    
    func checkwhetherallowedtoedit(y:@escaping progress)
    {
        
        print("timetable \(Dataservices.ds.client) \(self.passedclass) allowedtoedit")
      
        
       
        FIRDatabase.database().reference().child("timetable").child(Dataservices.ds.client).child(self.passedclass).child("allowedtoedit").observeSingleEvent(of: .value) { (snappy) in
            print(snappy.value)
            if let snk = snappy.value as? Dictionary<String,AnyObject> {
                var found = false
                
                for each in snk
                {
                   
                    if Dataservices.ds.userid == each.key {
                        found = true
                        break
                    }
                }
                if(found)
                {
                    y(true)
                }
                else
                {
                    y(false)
                }
            }
            
            }
        
    }
    
    
    
    
    func getnoofperiods(x:@escaping progress)
    {
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        
       
        
        print(self.passedclass)
        print(self.currentselectday.lowercased())
        FIRDatabase.database().reference().child("timetable").child(t).child(self.passedclass).child(self.currentselectday.lowercased()).observeSingleEvent(of: .value) { (snapshot) in
         
            let count = snapshot.childrenCount
            self.noofperiods = Int(count)
           
            if let snap = snapshot.value as? Dictionary<String,String> {
                var insideeachday : Dictionary<String,String> = [:]
                
                for s in snap {
                    
                    insideeachday[s.key] = s.value
                }
                
                self.alldaysdata["\(self.currentselectday.lowercased())"] = insideeachday
                self.alldaysperiods["\(self.currentselectday.lowercased())"] = Int(count)
                
               
                x(true)
            }
            else
            {
                x(false)
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alldaysperiods["\(self.currentselectday.lowercased())"] ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let kc = tableView.dequeueReusableCell(withIdentifier: "timetablevccell", for: indexPath) as? TeacherTimeTableTableViewCell {
            var cd = self.alldaysdata["\(self.currentselectday.lowercased())"]
            var subject = cd?["k\(indexPath.row)"]
            if cd?["k0"] == nil {
                kc.updatecell(period: indexPath.row+1, sub: cd?["k\(indexPath.row+1)"] ?? "")
            }
            else
            {
                kc.updatecell(period: indexPath.row, sub: subject ?? "")
            }
            return kc
            print("Subject is \(subject)")
            
        }
        return UITableViewCell()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? StatictimetableeditoneViewController {
            dest.passedclass = self.passedclass
        }
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
