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

class ArticlesTableViewCell: UITableViewCell {

    
    var onButtonTapped : (() -> Void)? = nil

    @IBOutlet var articleText : UILabel!
    
    @IBOutlet var articleURL: UILabel!
    
    @IBOutlet var plusButton : UIButton!
    
    @IBOutlet var articleInfo: UILabel!
    
    @IBOutlet var articleDate: UILabel!
    
    
    @IBAction func bluePress(sender: UIButton) {
        
        ArticlesViewController().getRecentPlaylist(sender.tag, info: articleText.text!, body: articleInfo.text!, date: articleDate.text!, url: articleURL.text!)
        
        
        
    }

}

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var source = ""
    var link = ""
    
    var articlesNames = [""]
    var articlesURL = [""]
    var articlesInfo = [""]
    var articlesDates = [""]
    var playlist = [["",""]]
    
    var data = false
    
    @IBOutlet var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // Do any additional setup after loading the view.

        
        
        var nib = UINib(nibName: "ArticlesTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "articleCell")
        
        articlesNames.removeAtIndex(0)
        articlesURL.removeAtIndex(0)
        
        print("This is the link: " + link)
        
        let url = NSURL(string: link)
        
        var nounArr = [""]
        nounArr.removeAll()
        
        
        
        if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                let urlError = false
                
                
                
                if error == nil {
                    
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                    var urlContentArray2 = urlContent.componentsSeparatedByString("false\">")
                    urlContentArray2.removeAtIndex(0)
                    
                    for i in urlContentArray2 {
                    
                        var arr3 = i.componentsSeparatedByString("</guid>")
                        self.articlesURL.append(arr3[0])
                        
                    }
                    
                    
                    var urlContentArray = urlContent.componentsSeparatedByString("<item><title>")
                    urlContentArray.removeAtIndex(0)
                    var finalTitle = [""]
                    finalTitle.removeAtIndex(0)
                    for i in urlContentArray {
                        var arr2 = i.componentsSeparatedByString("</title>")
                        finalTitle.append(arr2[0])
                    }
                    self.articlesNames = finalTitle

                    //GETTING INFO VALUE
                    
                    var infoContentArray = urlContent.componentsSeparatedByString("</link><description>")
                    infoContentArray.removeRange(0...2)
                    var finalInfo = [""]
                    finalInfo.removeAtIndex(0)
                    for i in infoContentArray {
                        var arr2 = i.componentsSeparatedByString("&lt;")
                        print(arr2[0])
                        finalInfo.append(arr2[0])
                    }
                    self.articlesInfo = finalInfo
                    
                    //GETTING DATE VALUE
                    
                    var datesContentArray = urlContent.componentsSeparatedByString("<pubDate>")
                    datesContentArray.removeRange(0...1)
                    var finalDates = [""]
                    finalDates.removeAtIndex(0)
                    for i in datesContentArray {
                        var arr2 = i.componentsSeparatedByString("</pubDate><guid isPermaLink=")
                        finalDates.append(arr2[0])
                    }
                    print(finalDates)
                    var trueDates = [""]
                    trueDates.removeAtIndex(0)
                    for date in finalDates {
                        var str2 = ""
                        var str = date.componentsSeparatedByString(" ")
                        var finalDate = str[4]
                        //print(finalDate)
                        var num1 = finalDate.componentsSeparatedByString(":")
                        //print(num1)
                        if Int(num1[0]) >= 12 {
                            str2 = String(Int(num1[0])!-12) + ":" + num1[1] + " PM"
                        }
                        else {
                            str2 = String(num1[0]) + ":" + String(num1[1]) + " AM"
                        }
                        trueDates.append(str2)
                    }
                    self.articlesDates = trueDates
                    
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if urlError == true {
                            
                            print("error")
                            
                        } else {
                            self.data = true
                            print("no error")
                            self.tableView.reloadData()
                            
                        }
                        
                        
                        
                    }
                }
                
            })
            
            task.resume()
            
            
        }
    
        
    }
    
    
    
    func getRectangle() {
    
        func addRectangle() {
            
            var DynamicView=UIView(frame: CGRectMake(100, 200, 100, 100))
            DynamicView.backgroundColor=UIColor.greenColor()
            DynamicView.layer.cornerRadius=25
            DynamicView.layer.borderWidth=2
            self.view.addSubview(DynamicView)
        }
    }
    
    func getSummaryOfArticle(url: String) {
    
        let url =  NSURL(string: link)
        if url != nil {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: {(data, response, error) -> Void in
            
                if error == nil {}
                
            
            })
        }
    
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Adding to playlist function. This will store the data in the parse database
    
    func getRecentPlaylist(num: Int, info : String, body: String, date: String, url: String) {
        
        PFUser.currentUser()!.fetchInBackgroundWithBlock({ (currentUser: PFObject?, error: NSError?) -> Void in
            
            // Update your data
            
            if let user = currentUser as? PFUser {
                
                self.playlist = user["playlist"] as! [Array<String>]
                
                print(self.playlist)
                
                self.addToPlaylist(num, info: info, body: body, date: date, url: url)
                
            }
        })
    
    }
    
    func addToPlaylist(num: Int, info : String, body : String, date: String, url: String) {
        
        if let currentUser = PFUser.currentUser() {
            
            self.playlist.append([info, body, url, date])
            
            currentUser["playlist"] = self.playlist
            
            currentUser.saveInBackground()
        
        }
        
        print(num)
        print(info)
        print(url)
        
    }
    
    // End adding function
    
    var finalArticle = ""
    var finalURL = ""
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("RETURNING ARTICLES NAMES")
        return 25
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        var cell:ArticlesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("articleCell") as! ArticlesTableViewCell
        
        if self.data {
        
            cell.articleText.text = self.articlesNames[indexPath.row]
            
            cell.articleURL.text = self.articlesURL[indexPath.row]
        
            cell.articleURL.hidden = true
            
            
            cell.articleInfo.text = self.articlesInfo[indexPath.row]
            
            
            cell.articleDate.text = self.articlesDates[indexPath.row]
            
            cell.plusButton.setBackgroundImage(UIImage(named: "blueplus.png"), forState: .Normal)
            
            cell.plusButton.tag = indexPath.row
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.finalArticle = self.articlesNames[indexPath.row]
        self.finalURL = self.articlesURL[indexPath.row]
        
        performSegueWithIdentifier("article", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "article" {
            var vc = segue.destinationViewController as! DisplayViewController
            
            vc.articleName = self.finalArticle
            vc.articleURL = self.finalURL
            
        
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
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
