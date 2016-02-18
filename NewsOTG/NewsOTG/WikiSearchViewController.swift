//
//  WikiSearchViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 2/17/16.
//  Copyright © 2016 Avinash Jain. All rights reserved.
//

import UIKit

var dataArray = [String]()
var filteredArray = [String]()
var shouldShowSearchResults = false



class WikiSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController!

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    @IBOutlet var tableView: UITableView!
    
    
    func loadLists() {
    
        let path1 = NSBundle.mainBundle().pathForResource("listOfBusinesses", ofType: "txt")
        let path2 = NSBundle.mainBundle().pathForResource("listOfFruits", ofType: "txt")
        let path3 = NSBundle.mainBundle().pathForResource("listOfCountries", ofType: "txt")
        
        do {
        var data1 = try String(contentsOfFile: path1!, encoding: NSUTF8StringEncoding)
        var data2 = try String(contentsOfFile: path2!, encoding: NSUTF8StringEncoding)
        var data3 = try String(contentsOfFile: path3!, encoding: NSUTF8StringEncoding)
            
        dataArray = data1.componentsSeparatedByString(",") + data2.componentsSeparatedByString(",") + data3.componentsSeparatedByString(",")
        }
        
        catch {
            print("Error")
        }
        
        //Array(string.characters)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLists()
        
        configureSearchController()
        
        print(dataArray)
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }

    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search here..."
        
        searchController.searchBar.delegate = self
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barStyle = UIBarStyle.Default
        
        tableView.tableHeaderView = searchController.searchBar
    }
    
    

    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        print(searchController.searchBar.text)
        
        searchController.searchBar.resignFirstResponder()
        
        performSegueWithIdentifier("gowiki", sender: self)
    }
    
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    let searchString = searchController.searchBar.text
    
    // Filter the data array and get only those countries that match the search text.
    filteredArray = dataArray.filter({ (text) -> Bool in
    let searchText: NSString = text
    
    return (searchText.rangeOfString(searchString!, options: NSStringCompareOptions.CaseInsensitiveSearch).location) != NSNotFound
    })
    
    // Reload the tableview.
    tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldShowSearchResults {
            return filteredArray.count
        }
        else {
            return 1
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("idCell", forIndexPath: indexPath) as! UITableViewCell
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredArray[indexPath.row]
            
        }
        else {
            cell.textLabel?.text = "Recent Searches"
        }
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as! DisplayViewController
        
        vc.articleName = searchController.searchBar.text!
        vc.articleURL = ("https://en.wikipedia.org/wiki/" + vc.articleName)
        vc.wiki = true
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
