//
//  AttendancePerClassViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 7/16/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase

class AttendancePerClassViewController: UIViewController ,  UITableViewDelegate , UITableViewDataSource {
 
    
    
    @IBOutlet weak var nodatawarning: UILabel!
    
    @IBOutlet weak var popupview: CustomView!
    
    @IBOutlet weak var datepicker: UIDatePicker!
    
    
    @IBOutlet weak var popuplabel: UILabel!
    
    @IBOutlet weak var popupcancel: UIButton!
    
    
    @IBOutlet weak var popupdone: UIButton!
    
    @IBOutlet weak var upperlabel: UILabel!
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var datebtnoutlet: UIButton!
    
    @IBOutlet weak var monthbtnoutlet: UIButton!
    

    @IBOutlet weak var yearbtnoutlet: UIButton!
    
    
    @IBOutlet weak var footerlabel: UILabel!
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    
    @IBOutlet weak var messagebtn: UIButton!
    
    
    var yearpart = "2019"
    var monthpart = "08"
    var daypart = "24"
    
    var monthname = ""
    
    var monthslist = ["jan","feb","mar","apr","may","june","july","aug","sep","oct","nov","dec"]
    var days = ["jan":31,"feb":28,"mar":31,"apr":30,"may":31,"june":30,"july":31,"aug":31,"sep":30,"oct":31,"nov":30,"dec":31]
    
    var selectedcategory = "days"
    
    
    var alldata : [attendanceperclasswise] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
       self.nodatawarning.isHidden = true
        self.popupview.isHidden = true
        self.upperviewheight.constant = self.view.frame.size.height/4
        setupfont()
        setupcurrenttime()
        datepicker.setValue(UIColor.white, forKey: "textColor")

        let date = NSDate()
        datepicker.setDate(date as Date, animated: false)
        self.datebtnoutlet.setTitle(self.daypart, for: .normal)
        self.monthbtnoutlet.setTitle(self.monthpart, for: .normal)
        self.yearbtnoutlet.setTitle(self.yearpart, for: .normal)
        self.table.reloadData()
        fetchdata()
        

        // Do any additional setup after loading the view.
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
            self.monthname = self.monthslist[Int(String(datearray[1]))! - 1]
            self.monthpart = (String(datearray[1]))
            self.yearpart = (String(datearray[0]))
            self.daypart = (String(datearray[2]))
            
            
        }
        
    }
    
    
    @IBAction func backbtnpressed(_ sender: UIButton) {
    }
    
    
    @IBAction func messagebtnpressed(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    
    func fetchdata()
    {
        self.alldata = []
        var userid = Dataservices.ds.userid
        var schoolid = Dataservices.ds.client
        userid = "teststudentid"
        schoolid = "xyz12345"
        
       print("students -> \(schoolid) -> \(userid) -> attendance -> \(yearpart) -> \(monthpart) -> \(daypart)")
        FIRDatabase.database().reference().child("students").child(schoolid).child(userid).child("attendance").child("\(yearpart)").child("\(monthpart)").child("\(daypart)").observeSingleEvent(of: .value) { (snappy) in
            
            print("Inside")
            
            if let snap = snappy.value as? Dictionary<String,String> {
                self.nodatawarning.isHidden = true
                for each in snap {
                    var k = each.key
                    var v = each.value
                    self.fetchfurtherdata(x: { (success) in
                        self.table.reloadData()
                    }, key: k, status: v, classcode : "c1bbasec1")
                }
                
            }
            else
            {
                self.nodatawarning.isHidden = false
                self.table.reloadData()
            }
            
        }
        
        
        
       
    }
    
    typealias str = (_ s:Bool) -> Void
    
    func fetchfurtherdata( x : @escaping str , key : String, status : String , classcode : String)
    {
        var userid = Dataservices.ds.userid
        var schoolid = Dataservices.ds.client
        userid = "teststudentid"
        schoolid = "xyz12345"
        

            print(schoolid)
        print(classcode)
        print(monthpart)
        print(yearpart)
        print(daypart)
        print(key)
        
        
    
        FIRDatabase.database().reference().child("timetable").child(schoolid).child(classcode).child(yearpart).child(monthpart).child(daypart).child(key).observeSingleEvent(of: .value) { (snao) in
            if let sn = snao.value as? Dictionary<String,String> {
                var x = attendanceperclasswise(begins: sn["begins"]!, ends: sn["ends"]!, room: sn["room"]!, subject: sn["subject"]!, takenby: sn["takenby"]!, attendancestatus: status)
                self.alldata.append(x)
                self.table.reloadData()
            }
            }
        
        
        
        
    }
    
    func setupfont()
    {
        upperlabel.font = upperlabel.font.withSize(Dataservices.ds.largefontsize)
        footerlabel.font = footerlabel.font.withSize(Dataservices.ds.smallfontsize)
        popuplabel.font = popuplabel.font.withSize(Dataservices.ds.midfontsize)
        nodatawarning.font = nodatawarning.font.withSize(Dataservices.ds.midfontsize)

        
        yearbtnoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        monthbtnoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        datebtnoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.smallfontsize)
        popupdone.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        popupcancel.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
    
    }
    
    
    
    
    
    
    
    
    
    @IBAction func popupcancelpressed(_ sender: UIButton) {
//        let date = NSDate()
//        datepicker.setDate(date as Date, animated: false)
        self.popupview.isHidden = true
    }
    
    
    
    @IBAction func popupdonepressed(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: self.datepicker.date)
        print(dateString)
        let datevalues = dateString.split(separator: "/")
        self.monthpart = String(datevalues[0])
        self.daypart =  String(datevalues[1])
        self.yearpart = String(datevalues[2])
        self.monthname = self.monthslist[Int(String(datevalues[0]))! - 1]
        self.datebtnoutlet.setTitle(self.daypart, for: .normal)
        self.monthbtnoutlet.setTitle(self.monthpart, for: .normal)
        self.yearbtnoutlet.setTitle(self.yearpart, for: .normal)
        fetchdata()
        self.popupview.isHidden = true

    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alldata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "attperclass", for: indexPath) as? AttendancePerClassTableViewCell
        {
            cell.updatecell(x: alldata[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 6
    }
    
    
    
    @IBAction func changedatepressed(_ sender: UIButton) {

        self.popupview.isHidden = false
    }
    
    
    @IBAction func changemonthpressed(_ sender: UIButton) {


        self.popupview.isHidden = false
    }
    
    
    @IBAction func changeyearpressed(_ sender: UIButton) {


        self.popupview.isHidden = false
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
