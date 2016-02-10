//
//  CategoriesViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/28/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit

class CategoriesTableViewCell : UITableViewCell {

    @IBOutlet var bgimage: UIImageView!
    
    @IBOutlet var category: UILabel!

}

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var source = ""
    
    var link = ""
    
    var categories = ["World", "Top Stories", "Tech", "Business", "Politics", "Health"]

    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "CategoriesTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "category")

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:CategoriesTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("category") as! CategoriesTableViewCell!
        
        cell.category.text = categories[indexPath.row]
        var str = self.categories[indexPath.row] + ".jpg"
        cell.bgimage.image = UIImage(named: str)
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row{
        case 0:
            World(self)
        case 1:
            topStories(self)
        case 2:
            Tech(self)
        case 3:
            Business(self)
        case 4:
            Politics(self)
        case 5:
            Health(self)
        default:
            print("Didn't work")
        }
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
