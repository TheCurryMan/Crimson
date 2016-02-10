//
//  ArticlesViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/22/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit
import Bolts
import Parse



class PlaylistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var source = ""
    var link = ""
    
    var articlesNames = [""]
    var articlesURL = [""]
    var playlist = [["",""]]
    
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        
        self.tableView.registerNib(nib, forCellReuseIdentifier: "articleCell")

        
        // Do any additional setup after loading the view.
        
        PFUser.currentUser()!.fetchInBackgroundWithBlock({ (currentUser: PFObject?, error: NSError?) -> Void in
            
            // Update your data
            
            if let user = currentUser as? PFUser {
                
                self.playlist = user["playlist"] as! [Array<String>]
                self.playlist.removeAtIndex(0)
                
                print(self.playlist)
                
                print("SI THIS WORKING ")
                
                
                self.tableView.reloadData()
                
            
                
            }
        })
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Adding to playlist function. This will store the data in the parse database
    
    
    // End adding function
    
    var finalArticle = ""
    var finalURL = ""
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return playlist.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:ArticlesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("articleCell") as! ArticlesTableViewCell
        
        if self.playlist != [["",""]] {
        
            var text1 = self.playlist[indexPath.row]
            
            cell.articleText.text = text1[0]
        
        print(cell.articleText.text)
            
            cell.articleURL.text = text1[1]
            
            cell.articleURL.hidden = true
            
            
            
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.finalArticle = self.articlesNames[indexPath.row]
        self.finalURL = self.articlesURL[indexPath.row]
        
        performSegueWithIdentifier("article2", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "article2" {
            var vc = segue.destinationViewController as! DisplayViewController
            
            vc.articleName = self.finalArticle
            vc.articleURL = self.finalURL
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            self.playlist.removeAtIndex(indexPath.row)
            
            self.tableView.reloadData()

            
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
