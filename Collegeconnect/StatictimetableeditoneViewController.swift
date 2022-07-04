//
//  StatictimetableeditoneViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 10/28/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit

class StatictimetableeditoneViewController: UIViewController , UITableViewDelegate , UITableViewDataSource   {

    
    
    
    
    

    var days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]

    var selectedday = ""
    
    var classcode = ""
    
    @IBOutlet weak var upperviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    var passedclass = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upperviewheight.constant = self.view.frame.size.height/3
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadData()
        self.classcode = self.passedclass

        titlelabel.font = titlelabel.font?.withSize(Dataservices.ds.midfontsize)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backbtnpressed(_ sender: UIButton) {
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedday = self.days[indexPath.row]
        performSegue(withIdentifier: "daydigging", sender: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell =  tableView.dequeueReusableCell(withIdentifier: "statictimetableone", for: indexPath) as? StaticTimeTablescreenoneTableViewCell {
            cell.updatecell(x: self.days[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height / 6
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let seg = segue.destination as? StatictimetablescreentwoViewController {
            seg.currentselectday = self.selectedday.lowercased()
            seg.currentselectedclasscode = self.passedclass
            seg.currentselectedclass = self.passedclass
        }
    }
    

   
    
   
    

}
