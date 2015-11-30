//
//  ViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/22/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit

class SourceTableViewCell : UITableViewCell {

    @IBOutlet var sourceButton : UIButton!
    

    
    @IBAction func sourceClick(sender: UIButton) {
        
        if sender.tag == 0 {
        
             NSNotificationCenter.defaultCenter().postNotificationName("CNN", object: nil)
            
        }
        
        else if sender.tag == 1 {
            
            NSNotificationCenter.defaultCenter().postNotificationName("BBC", object: nil)
        
        }
        
        else if sender.tag == 2 {
        
            NSNotificationCenter.defaultCenter().postNotificationName("Wiki", object: nil)
        
        }
        
        
    }

}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var finalSource = ""
    
    var sources = ["CNN", "BBC", "Wikipedia"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"CNN", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"BBC", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"Wiki", object: nil)
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // Do any additional setup after loading the view, typically from a nib.
        
        var nib = UINib(nibName: "SourceTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "sourceCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:SourceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("sourceCell") as! SourceTableViewCell
        
        cell.sourceButton.setBackgroundImage(UIImage(named: sources[indexPath.row] + ".png"), forState: UIControlState.Normal)
        cell.sourceButton.tag = indexPath.row
        
        
        print(sources[indexPath.row]+".png")
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("You selected cell #\(indexPath.row)!")
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
    
    func methodOFReceivedNotication(notification: NSNotification){
        
        if notification.name == "CNN" {
            
            finalSource = "CNN"
        
            self.performSegueWithIdentifier("articles", sender: self)
            
        }
        
        if notification.name == "BBC" {
        
            finalSource = "BBC"
            
            self.performSegueWithIdentifier("articles", sender: self)
        
        }
        
        if notification.name == "Wiki" {
            
            finalSource = "Wiki"
            
            self.performSegueWithIdentifier("articles", sender: self)
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "articles" {
        
            var vc = segue.destinationViewController as! CategoriesViewController
            
            vc.source = finalSource
            
        }
    }
    


}

