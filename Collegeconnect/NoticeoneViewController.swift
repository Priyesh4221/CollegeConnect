//
//  NoticeoneViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 12/23/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase

class NoticeoneViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var headertitle: UILabel!
    
    @IBOutlet weak var headerviewheight: NSLayoutConstraint!
    
    var passedclasscode = "c1bbasec1"
    var allnewsid : [String] = []
    var data : [news] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupfont()
        self.table.delegate =  self
        self.table.dataSource = self
        self.headerviewheight.constant = self.view.frame.size.height/4
        self.fetchinitialdata { (res) in
            if(res) {
                self.fetchsecondphase { (rr) in
                    if(rr) {
                        self.table.reloadData()
                    }
                    else {
                        
                    }
                }
            }
            else {
                
            }
        }
    }
    
    
    func setupfont()
    {
        headertitle.font = headertitle.font?.withSize(Dataservices.ds.largefontsize)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "noticeone", for: indexPath) as? NoticeoneTableViewCell {
            
            cell.updatecell(z:self.data[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    typealias progress = (_ s : Bool) -> Void
    
    func fetchinitialdata(y:@escaping progress)
    {
        var clientid = Dataservices.ds.client
        var classcode = self.passedclasscode
        clientid = "xyz12345"
        FIRDatabase.database().reference().child("newsviewer").child("\(clientid)").child("\(classcode)").observeSingleEvent(of: .value) { (snapshot) in
                if let snap = snapshot.value as? Dictionary<String,AnyObject> {
                    for eachnews in snap {
                        print(eachnews.key)
                        self.allnewsid.append(eachnews.key)
                    }
                    y(true)
                }
                else
                {
                    y(false)
                }
            }
        
    }
    
    
    func fetchsecondphase(y:@escaping progress)
    {
        var clientid = Dataservices.ds.client
        var classcode = self.passedclasscode
        clientid = "xyz12345"
        
        for k in self.allnewsid {
            FIRDatabase.database().reference().child("news").child("\(clientid)").child("\(k)").observeSingleEvent(of: .value) { (snapp) in
                    if let sn = snapp.value as? Dictionary<String,AnyObject> {
                        var s = ""
                        var ex = 0
                        var upon = 0
                        var upid = ""
                        var upname = ""
                        if let ss = sn["subject"] as? String {
                            s = ss
                        }
                        if let exx = sn["expireson"] as? Int {
                            ex = exx
                        }
                        if let uponn = sn["uploadedon"] as? Int {
                            upon = uponn
                        }
                        if let upidd = sn["uploadedby"] as? String {
                            upid = upidd
                        }
                        if(upid != "") {
                            self.fetchteachername(y: { (sec) in
                                print("Got response \(sec)")
                                upname = sec
                                var x  = news(postedby: upname, postedon: upon, expireson: ex, content: s)
                                self.data.append(x)
                                print(self.data)
                                
                                self.table.reloadData()
                            }, t: upid)
                        }
                        
                    }
                }
        }
        y(true)
        
    }
    
    typealias progress2 = (_ s : String) -> Void
    func fetchteachername(y:@escaping progress2 , t : String) {
        var clientid = Dataservices.ds.client
        var classcode = self.passedclasscode
        clientid = "xyz12345"
        FIRDatabase.database().reference().child("teachers").child("\(clientid)").child("\(t)").child("basic").child("name").observeSingleEvent(of: .value) { (ss) in
            if let sss = ss.value as? String{
                print(sss)
                y(sss)
            }
        }
        
    }
    
    

    @IBAction func backpressed(_ sender: UIButton) {
    }
    
    @IBAction func messagepressed(_ sender: UIButton) {
    }
    
}
