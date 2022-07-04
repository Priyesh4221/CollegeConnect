//
//  LoginViewController.swift
//  Collegeconnect
//
//  Created by PRIYESH  on 6/21/19.
//  Copyright © 2019 PRIYESH . All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    
    
    
    
    
    @IBOutlet weak var forgotpasswordoutlet: UIButton!
    
    @IBOutlet weak var welcomefontset: UILabel!
    
    
    @IBOutlet weak var logintoyouraccountfontset: UILabel!
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var loginbtnoutlet: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setfonts()
        print(Dataservices.ds.userid)

    
       self.email.layer.cornerRadius = self.email.layer.frame.size.height / 1.5
        self.password.layer.cornerRadius = self.password.layer.frame.size.height / 1.5
        self.loginbtnoutlet.layer.cornerRadius = self.loginbtnoutlet.layer.frame.size.height / 2
        
        self.email.delegate = self
        self.password.delegate = self
        
        self.email.addCharacterSpacing(kernValue : 15)
        self.password.addCharacterSpacing(kernValue : 15)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        

    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print("up")
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("up up")
            if view.frame.origin.y == 0{
               
                let height = keyboardSize.height
                 print("up up up \(height)")
                
                self.view.frame.origin.y -= height
            }
            
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("down")
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("down down")
            if view.frame.origin.y != 0 {
                let height = keyboardSize.height
                print("down down \(height)")
                self.view.frame.origin.y += height
            }
            
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        email.resignFirstResponder()
        password.resignFirstResponder()
        return false
    }
    
    func setfonts()
    {
        welcomefontset.font = welcomefontset.font.withSize(Dataservices.ds.largefontsize)
        logintoyouraccountfontset.font = logintoyouraccountfontset.font.withSize(Dataservices.ds.smallfontsize)
        
        email.font = email.font?.withSize(Dataservices.ds.smallfontsize)
        password.font = email.font?.withSize(Dataservices.ds.smallfontsize)
        

        
        forgotpasswordoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight", size: Dataservices.ds.midfontsize)
        loginbtnoutlet.titleLabel?.font =  UIFont(name: "SofiaProLight" , size: Dataservices.ds.midfontsize * 1.2)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
      

    }
    
    @IBAction func loginpressed(_ sender: UIButton) {
        print("hello")
        if let em = self.email.text ,let pa = self.password.text
        {
            
        
            
            
            
            
            FIRAuth.auth()?.signIn(withEmail: em, password: pa, completion: { (user, error) in
                print("\(em) \(pa)")
                var x = "An internal error has occurred, print and inspect the error details for more information."
                if (error != nil && error?.localizedDescription != x )
                {
                    print("User does not exist \(error?.localizedDescription)")
                }
                else
                {
                    if let k = user?.uid
                    {
                        KeychainWrapper.standard.set(k, forKey: "auth")
                        Dataservices.ds.userid = k
                        self.fetchdata { (success) in
                            if(success)
                            {
                                print(Dataservices.ds.enrolledclasses)
                                self.performSegue(withIdentifier: "logintostudent", sender:nil)
                            }
                        }
                        
                    }
                }
            })
            
        }
    }
    
    
    
    @IBAction func forgotpasswordclicked(_ sender: UIButton) {
    }
    
    
    
    
    typealias fetcheddata = (_ success:Bool) -> Void
    func fetchdata(status : @escaping fetcheddata)
    {
        if let userid = KeychainWrapper.standard.string(forKey: "auth") {
            
           print("user id \(userid)")
            FIRDatabase.database().reference().child("schools").child(userid).observeSingleEvent(of: .value) { (stusnap) in
                if let student = stusnap.value as? Dictionary<String,AnyObject> {
                    print(student)
                    if let client = student["client"] as? String{
                        KeychainWrapper.standard.set(client, forKey: "client")
                        Dataservices.ds.client = client
                        print("Client is \(client)")
                    }
                    if let role = student["role"] as? String{
                        KeychainWrapper.standard.set(role, forKey: "role")
                        Dataservices.ds.role = role
                        
                        if role == "student" {
                            if let enroll = student["enrolledclasses"] as?
                                Dictionary<String,String> {
                               
                                Dataservices.ds.enrolledclasses = enroll
                                
                            }
                        }
                    }
                    
                }
                status(true)
            }
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


