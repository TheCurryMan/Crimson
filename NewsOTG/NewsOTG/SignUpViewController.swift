//
//  SignUpViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 12/1/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//



import UIKit
import Parse
import Bolts

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func signUp(sender: UIButton) {
        
        var em = email.text
        var us = username.text
        var pass = password.text
        
        
        var user = PFUser()
        user.username = us
        user.password = pass
        user.email = em
        user["playlist"] = []
        
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                print(errorString)
            } else {
                print("Namaste")
                self.performSegueWithIdentifier("main", sender: self)
            }
            
        }
        
        
        
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
