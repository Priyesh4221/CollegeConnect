//
//  LogoViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 10/27/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class LogoViewController: UIViewController {
    
    
    @IBOutlet weak var college: UILabel!
    
    @IBOutlet weak var connect: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        college.font = college.font.withSize(Dataservices.ds.largefontsize * 1.5)
        connect.font = connect.font.withSize(Dataservices.ds.smallfontsize * 1.5)
        
        
        

        // Do any additional setup after loading the view.
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
       
        print("User id : \(KeychainWrapper.standard.string(forKey: "auth"))")
        
        
        if let id = KeychainWrapper.standard.string(forKey: "auth")
        {
            Dataservices.ds.userid = id
            if let c = KeychainWrapper.standard.string(forKey: "client") {
                 Dataservices.ds.client = c
            }
            if let r = KeychainWrapper.standard.string(forKey: "role") {
                Dataservices.ds.role = r
            }

            
            
           
            if(Dataservices.ds.role == "student") {
                FIRDatabase.database().reference().child("schools").child(id).child("enrolledclasses").observeSingleEvent(of: .value) { (snap) in
                        if let snapsh = snap.value as? Dictionary<String,String> {
                            Dataservices.ds.enrolledclasses = snapsh
//                            self.performSegue(withIdentifier: "logototest", sender: nil)
                            self.performSegue(withIdentifier: "alreadyloggedin", sender: nil)
                        }
                }
            }
            else
            {
//                    self.performSegue(withIdentifier: "logototest", sender: nil)
                self.performSegue(withIdentifier: "alreadyloggedin", sender: nil)
            }
        
            
        }
        else
        {
             self.performSegue(withIdentifier: "logotologin", sender: nil)
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



extension UILabel {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}


extension UITextField {
    func addCharacterSpacing(kernValue: Double = 1.15) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}



extension UILabel {
    public var substituteFontName : String {
        get {
            return self.font.fontName;
        }
        set {
            var fontName = newValue;
            print(fontName)
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextView {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
           
            var fontName = newValue;
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}

extension UITextField {
    public var substituteFontName : String {
        get {
            return self.font?.fontName ?? "";
        }
        set {
           
            var fontName = newValue;
            
            self.font = UIFont(name: fontName, size: self.font?.pointSize ?? 17)
        }
    }
}


