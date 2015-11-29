//
//  CategoriesViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/28/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    var source = ""
    
    var link = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func topStories(sender: AnyObject) {
        getData(source, cat: "top")
    }
    
    @IBAction func World(sender: AnyObject) {
        getData(source, cat: "world")
    }
    
    @IBAction func Tech(sender: AnyObject) {
        getData(source, cat: "tech")
    }
    
    @IBAction func Business(sender: AnyObject) {
        getData(source, cat: "bus")
    }
    
    @IBAction func Politics(sender: AnyObject) {
        getData(source, cat: "pol")
    }
    
    @IBAction func Health(sender: AnyObject) {
        getData(source, cat: "health")
    }
    
    func getData(source: String, cat: String) {
       
        if source == "CNN" {
            switch cat {
                
                case "top":
                    self.link = "http://rss.cnn.com/rss/cnn_topstories.rss"
                    print(link)
                case "world":
                    link = "http://rss.cnn.com/rss/cnn_world.rss"
                case "tech":
                    link = "http://rss.cnn.com/rss/cnn_tech.rss"
                case "bus":
                    link = "http://rss.cnn.com/rss/money_latest.rss"
                case "pol":
                    link = "http://rss.cnn.com/rss/cnn_allpolitics.rss"
                case "health":
                    link = "http://rss.cnn.com/rss/cnn_health.rss"
                default:
                    link = "http://rss.cnn.com/rss/cnn_world.rss"
            
            }
        }
        
        performSegueWithIdentifier("getdata", sender: self)
        
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "getdata" {
        
        var vc = segue.destinationViewController as! ArticlesViewController
        
        vc.link = link
            
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
