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
    var playlist = [["","","",""]]
    
    var all = false
    
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
                
                for i in self.playlist {
                    self.articlesNames.append(i[0])
                    self.articlesURL.append(i[2])
                }
                
                self.articlesNames.removeFirst()
                self.articlesURL.removeFirst()
                
                print("article names: \n\n")
                print(self.articlesNames)
                
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
            
            cell.articleInfo.text = text1[1]
            
            cell.articleURL.text = text1[2]
            
            cell.articleDate.text = text1[3]
            
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
            
            if all == true {
                print(self.articlesNames)
                vc.listOfArticles = self.articlesNames
                vc.listOfUrls = self.articlesURL
                
            }
            
            else {
            
            
            print(self.finalURL)
            print(self.finalArticle)
            
            vc.articleName = self.finalArticle
            vc.articleURL = self.finalURL
                
            }
            
            
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
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
    
    
    @IBAction func playAll(sender: AnyObject) {
        
           all = true
        
        performSegueWithIdentifier("article2", sender: self)
        
     
    }
    
    
    
    
    
    
}
