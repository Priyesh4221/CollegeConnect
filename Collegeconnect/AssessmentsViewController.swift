//
//  AssessmentsViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/25/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AssessmentsViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var nodatawarning: UILabel!
    
    @IBOutlet weak var upperlabel: UILabel!
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    
    @IBOutlet weak var loader: Circularloader!
    
    @IBOutlet weak var detailsview: CustomView!
    
    
    @IBOutlet weak var topicname: UILabel!
    
    
    @IBOutlet weak var marksobtained: UILabel!
    
    
    @IBOutlet weak var subjectname: UILabel!
    
    
    @IBOutlet weak var testtakenon: UILabel!
    
    
    @IBOutlet weak var resultsouton: UILabel!
    
    
    @IBOutlet weak var resultgivenby: UILabel!
    
    
    @IBOutlet weak var remarks: UILabel!
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    @IBOutlet weak var messagebtn: UIButton!
    
    
    
    var pending = [test]()
   
    var results = [assessmentstruct]()
    
    @IBOutlet weak var segments: UISegmentedControl!
    
    @IBOutlet weak var collection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collection.delegate = self
        self.collection.dataSource = self
         self.detailsview.isHidden = true
        nodatawarning.isHidden = true
        // To be Deleted Later
        
        Dataservices.ds.userid = KeychainWrapper.standard.string(forKey: "auth")!
            Dataservices.ds.client
                = KeychainWrapper.standard.string(forKey: "client")!
        Dataservices.ds.role
            = KeychainWrapper.standard.string(forKey: "role")!
    
        
        if(Dataservices.ds.role == "student") {
            FIRDatabase.database().reference().child("schools").child(Dataservices.ds.userid).child("enrolledclasses").observeSingleEvent(of: .value) { (snap) in
                if let snapsh = snap.value as? Dictionary<String,String> {
                    Dataservices.ds.enrolledclasses = snapsh
                    self.takedata()
                }
            }
        }
        
        // Till here

       
        self.upperviewheight.constant = self.view.frame.size.height/4
        upperlabel.font = upperlabel.font.withSize(Dataservices.ds.largefontsize)
        
                topicname.font = topicname.font.withSize(Dataservices.ds.largefontsize)
                marksobtained.font = marksobtained.font.withSize(Dataservices.ds.smallfontsize)
                subjectname.font = subjectname.font.withSize(Dataservices.ds.smallfontsize)
                testtakenon.font = testtakenon.font.withSize(Dataservices.ds.smallfontsize)
                resultsouton.font = resultsouton.font.withSize(Dataservices.ds.smallfontsize)
                resultgivenby.font = resultgivenby.font.withSize(Dataservices.ds.smallfontsize)
                remarks.font = remarks.font.withSize(Dataservices.ds.midfontsize)
        
                nodatawarning.font = nodatawarning.font.withSize(Dataservices.ds.midfontsize)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closedetailviewpressed(_ sender: UIButton) {
        self.detailsview.isHidden = true
    }
    
    
    
    @IBAction func backpressed(_ sender: UIButton) {
    }
    
    
    @IBAction func messagepressed(_ sender: UIButton) {
    }
    
    
    func takedata()
    {
        self.results = []
        var s = Dataservices.ds.userid
        var t = Dataservices.ds.client
        var c = Dataservices.ds.enrolledclasses
        
        print("\(s) ------------ \(t) ------------- \(c)")
        

        FIRDatabase.database().reference().child("students/\(t)").child("\(s)").child("assessment").observeSingleEvent(of: .value) { (ss) in
            
                if let sse = ss.value as? Dictionary<String,AnyObject>
                {
                    if self.segments.selectedSegmentIndex == 1 {
                    self.nodatawarning.isHidden = true
                    }
                    for sst in sse
                    {
                        print(sst.key)
                        if let sstt = sst.value as? Dictionary<String,AnyObject>
                        {
                            if let marks = sstt["marks"] as? Int ,let totalmarks = sstt["totalmarks"] as? Int, let remark = sstt["remark"] as? String ,let asb = sstt["assessedby"] as? String , let rsp = sstt["resultpostedon"] as? String , let sub = sstt["subject"] as? String, let tto = sstt["testtakenon"] as? String , let tpc = sstt["topic"] as? String
                            {
                                self.fetchfurther(x: asb as! String) { (d) in
                                    var x = assessmentstruct(id: sst.key, marks: marks as! Int, totalmarks: totalmarks as! Int, remark: remark as! String, assessedby: d.capitalized, resultpostedon: rsp, subject: sub, testtakenon: tto, topic: tpc)
                                    self.results.append(x)
                                    self.collection.reloadData()
                                }
                               
                            }
                        }
                    }
                    
                }
                else
                {
                    if self.segments.selectedSegmentIndex == 1 {
                        self.nodatawarning.isHidden = false
                    }
                }
            }
        
        for cla in c {
            
            FIRDatabase.database().reference().child("classcodes").child("\(cla.key)").child("testspermitted").observeSingleEvent(of: .value) { (snapshot) in
                if let snap = snapshot.value as? Dictionary<String,AnyObject>
                {
                    if self.segments.selectedSegmentIndex == 0 {
                        self.nodatawarning.isHidden = true
                    }
                    self.pending = []
                    for s in snap
                    {
                        if let id = s.key as? String , let allowed = s.value as? Bool
                        {
                            
                            FIRDatabase.database().reference().child("tests").child(t).child(id).child("basic").observeSingleEvent(of: .value) { (snope) in
                                
                                if let sn = snope.value as? Dictionary<String,AnyObject>
                                {
                                    
                                    if let d = sn["duration"] as? String, let exp = sn["expireson"] as? String , let mcq = sn["mcq"] as? Bool , let postedby = sn["postedby"] as? String , let postedon = sn["postedon"] as? String, let retest = sn["retest"] as? Bool , let subject = sn["subject"] as? String , let subjective = sn["subjective"] as? Bool, let topic = sn["topic"] as? String
                                    {
                                        self.fetchfurther(x: postedby) { (res) in
                                            var te = test(id: id, expireson: exp, mcq: mcq, subjectives: subjective, postedby: res.capitalized, postedon: postedon, retest: retest, subject: subject, duration: d, topic: topic)
                                            self.pending.append(te)
                                            self.collection.reloadData()
                                        }

                                        
                                        
                                        
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                else
                {
                    if self.segments.selectedSegmentIndex == 0 {
                        self.nodatawarning.isHidden = false
                    }
                }
            }

            
        }
        
            
            
        
    }
    
    
    typealias fetched = (_ s:String) -> Void
    
    func fetchfurther(x:String , y : @escaping fetched) {
        FIRDatabase.database().reference().child("teachers").child(Dataservices.ds.client).child(x).child("name").observeSingleEvent(of: .value) { (snap) in
            if let snappy = snap.value as? String {
                print("\(snappy) &&&&&&&&&&&&&&&&&&&&&&&&&&")
                y(snappy)
            }
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.collection.frame.size.height/2.5 < 120
        {
            return CGSize(width: self.collection.frame.size.width, height:120)
        }
        else
        {
            return CGSize(width: self.collection.frame.size.width, height: self.collection.frame.size.height/2.5)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.segments.selectedSegmentIndex == 0
        {
            if self.pending.count == 0 {
                self.nodatawarning.isHidden = false
            }
            else
            {
                self.nodatawarning.isHidden = true
            }
            return self.pending.count
        }
        else
        {
            if self.results.count == 0 {
                self.nodatawarning.isHidden = false
            }
            else
            {
                self.nodatawarning.isHidden = true
            }
            return self.results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testcell", for: indexPath) as? AssessmentCollectionViewCell
        {
            if self.segments.selectedSegmentIndex == 0
            {
                cell.updatecell(t: self.pending[indexPath.row])
            }
            else
            {
                cell.updatecell(a: self.results[indexPath.row])
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.segments.selectedSegmentIndex == 1 {
            self.topicname.text = self.results[indexPath.row].topic.capitalized
            self.marksobtained.text = "Marks Obtained : \(self.results[indexPath.row].marks) / \(self.results[indexPath.row].totalmarks)"
            self.subjectname.text = "Subject : \(self.results[indexPath.row].subject.capitalized)"
            self.testtakenon.text = "Test Taken on :  \(self.results[indexPath.row].testtakenon)"
            self.resultsouton.text = "Results Out on : \(self.results[indexPath.row].resultpostedon)"
            self.resultgivenby.text = "Result Given By : \(self.results[indexPath.row].assessedby.capitalized)"
            self.remarks.text = "Remark : \(self.results[indexPath.row].remark.capitalized)"
            
            
            if let tm = self.results[indexPath.row].totalmarks as? Int {
                loader.safePercent = tm
            }

            loader.labelSize = 0

            var percentage  = Double(self.results[indexPath.row].marks) / Double(self.results[indexPath.row].totalmarks)

            loader.setProgress(to: percentage, withAnimation: true)

            
            self.detailsview.isHidden = false
        }
    }
    
   
    
    @IBAction func segmenttapped(_ sender: UISegmentedControl) {
        if self.pending.count == 0 && self.results.count == 0
        {
            takedata()
        }
        else
        {
            self.collection.reloadData()
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
