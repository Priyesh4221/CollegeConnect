//
//  ContentViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/21/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class ContentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    
    
    
    @IBOutlet weak var selectsegment: UISegmentedControl!
    
    @IBOutlet weak var table: UITableView!
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self

        fetchdata( status: { (success) -> Void in
            if(success)
            {
                self.table.reloadData()
            }
            else
            {
                print("----------------------------------------Got False")
            }
        })
    }
    
    
    
    @IBAction func segmentchangedvalue(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        
        fetchdata( status: { (success) -> Void in
            if(success)
            {
                self.table.reloadData()
            }
            else
            {
                print("----------------------------------------Got False")
            }
        })
        self.table.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.selectsegment.selectedSegmentIndex == 0)
        {
            return self.recentlectures.count
        }
        else if(self.selectsegment.selectedSegmentIndex == 1)
        {
            return self.lectures.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contcell", for: indexPath) as? ContentTableViewCell
        {
            
            if(self.selectsegment.selectedSegmentIndex == 0)
            {
                cell.updatecellrecent(b: self.recentlectures[indexPath.row])
            }
            else if(self.selectsegment.selectedSegmentIndex == 1)
            {
                cell.updatecell(b: self.lectures[indexPath.row])
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    var selectedvideo : recentlecturestruct?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.table.deselectRow(at: indexPath, animated: true)
        if(self.selectsegment.selectedSegmentIndex == 0)
        {
            selectedvideo = recentlectures[indexPath.row]
        }
        else if(self.selectsegment.selectedSegmentIndex == 1)
        {
           selectedvideo = recentlecturestruct(lectureitem: lectures[indexPath.row], duration: 0)
        }
        performSegue(withIdentifier: "taketoindividualcontent", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? Content2ViewController
        {
            if let pv = selectedvideo as? recentlecturestruct
            {
                seg.passedvideo = pv
            }
        }
    }
    
    

    @IBAction func filterpressed(_ sender: UIButton) {
    }
    
    
    var lectures = [lecturestruct]()
    var recentlectures = [recentlecturestruct]()
    
    typealias fetcheddata = (_ success:Bool) -> Void
    func fetchdata(status : @escaping fetcheddata)
    {
        
        var s = KeychainWrapper.standard.string(forKey: "auth")!
        var t = KeychainWrapper.standard.string(forKey: "school")!
        var c = KeychainWrapper.standard.string(forKey: "classcode")!
        
        print("\(t)   \(c)")
        
        
        
        
        
        
        
        
        if(selectsegment.selectedSegmentIndex == 0 && recentlectures.count == 0)
        {
            FIRDatabase.database().reference().child("students").child(t).child(s).child("lecturesviewed").observeSingleEvent(of: .value) { (sse) in
                if let res = sse.value as? Dictionary<String,AnyObject>
                {
                    for r in res
                    {
                        print(r.key)
                        FIRDatabase.database().reference().child("contents").child(t).child(r.key as? String ?? "").observeSingleEvent(of: .value) { (sssse) in
                            
                            if let coursedetails = sssse.value as? Dictionary<String,AnyObject> , let k = sssse.key as? String
                            {
                                let x = lecturestruct(lecid: k, lecname: coursedetails["name"] as! String, type: coursedetails["type"] as! String, duration: coursedetails["duration"] as! String, uploadedby: coursedetails["uploadedby"] as! String, uploadedon: coursedetails["uploadedon"] as! String, url: coursedetails["url"] as! String)
                                let y = recentlecturestruct(lectureitem: x, duration: r.value as? Int ?? 0)
                                self.recentlectures.append(y)
                                self.table.reloadData()
                            }
                            
                        }
                    }
                    status(true)
                }
                
            }

        }
        else if(selectsegment.selectedSegmentIndex == 1 && lectures.count == 0)
        {
        FIRDatabase.database().reference().child("contentviewer").child(t).child(c).observeSingleEvent(of: .value) { (sse) in
                if let res = sse.value as? Dictionary<String,AnyObject>
                {
                        for r in res
                        {
                            FIRDatabase.database().reference().child("contents").child(t).child(r.key as? String ?? "").observeSingleEvent(of: .value) { (sssse) in
                                
                                    if let coursedetails = sssse.value as? Dictionary<String,AnyObject> , let k = sssse.key as? String
                                    {
                                        let x = lecturestruct(lecid: k, lecname: coursedetails["name"] as! String, type: coursedetails["type"] as! String, duration: coursedetails["duration"] as! String, uploadedby: coursedetails["uploadedby"] as! String, uploadedon: coursedetails["uploadedon"] as! String, url: coursedetails["url"] as! String)
                                        self.lectures.append(x)
                                        self.table.reloadData()
                                    }
                                
                                }
                        }
                        status(true)
                }
            
            }
        }
        
        
    }
    
    
    
    
    
    

}
