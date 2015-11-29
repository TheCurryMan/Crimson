//
//  ArticlesViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/22/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var source = ""
    var link = ""
    
    var articlesNames = [""]
    var articlesURL = [""]
    
    @IBOutlet var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        articlesNames.removeAtIndex(0)
        articlesURL.removeAtIndex(0)
        
        print(link)
        
        let url = NSURL(string: link)
        
        var nounArr = [""]
        nounArr.removeAll()
        
        
        
        if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                let urlError = false
                
                
                
                if error == nil {
                    
                    
                    
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                  
                    
                    var nounArray = [""]
                    
                    var urlContentArray2 = urlContent.componentsSeparatedByString("false\">")
                    
                    urlContentArray2.removeAtIndex(0)
                    
                    var arr3 = [""]
                    arr3.removeAtIndex(0)
                    
                    for i in urlContentArray2 {
                    
                        var arr3 = i.componentsSeparatedByString("</guid>")
                        self.articlesURL.append(arr3[0])
                        
                    
                    }
                    
                    
                    
                    var urlContentArray = urlContent.componentsSeparatedByString("<item><title>")
                    
                    urlContentArray.removeAtIndex(0)
                    
                    var finalText = [""]
                    
                    finalText.removeAtIndex(0)
                    
                    for i in urlContentArray {
                        
                        var arr2 = i.componentsSeparatedByString("</title>")
                        finalText.append(arr2[0])
                        
                    }
                    
                    print(finalText)
                    
                    self.articlesNames = finalText
                    /*
                    
                    print(nounArray)
                    
                    for (var i = 0; i < 4; i++) {
                        
                        
                        
                        nounArr.append(nounArray[i])
                        
                        
                        
                    }
                    
                    
                    */
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if urlError == true {
                            
                            print("error")
                            
                        } else {
                            
                            print("no error")
                            self.tableView.reloadData()
                            print("Why isnt this working")
                        }
                        
                        
                        
                    }
                }
                
            })
            
            task.resume()
            
            
        }
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var finalArticle = ""
    var finalURL = ""
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("RETURNING ARTICLES NAMES")
        return 25
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
      
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        if self.articlesNames != [] {
        
        
        cell.textLabel?.text = self.articlesNames[indexPath.row]
            
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
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
