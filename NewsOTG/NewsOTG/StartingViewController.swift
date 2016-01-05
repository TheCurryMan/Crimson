//
//  HomeViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 12/1/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit
import Parse
import Bolts

class StartingViewController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            performSegueWithIdentifier("there", sender: self)
        } else {
            // Show the signup or login screen
            print("no user")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
