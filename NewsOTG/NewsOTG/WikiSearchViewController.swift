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



class WikiSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, OEEventsObserverDelegate {
    
    var searchController: UISearchController!

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor!
    
    var wikiText = ""
    
    var startedListening = false
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        
        //if startedListening == false {
            //viewDidLoad()
        //}
        
    }
    
    
    func loadLists() {
        
        
        
        let path1 = NSBundle.mainBundle().pathForResource("listOfBusinesses", ofType: "txt")
        let path2 = NSBundle.mainBundle().pathForResource("listOfFruits", ofType: "txt")
        let path3 = NSBundle.mainBundle().pathForResource("listOfCountries", ofType: "txt")
        
        do {
        var data1 = try String(contentsOfFile: path1!, encoding: NSUTF8StringEncoding)
        var data2 = try String(contentsOfFile: path2!, encoding: NSUTF8StringEncoding)
        var data3 = try String(contentsOfFile: path3!, encoding: NSUTF8StringEncoding)
            
        dataArray = data1.componentsSeparatedByString(",") + data2.componentsSeparatedByString(",") + data3.componentsSeparatedByString(",")
        
            for i in dataArray {
                var arr = i.uppercaseString.componentsSeparatedByString(" ")
                for j in arr {
                words.append(j)
                }
            }
            
            print(words)

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
        
        loadOpenEars()
        
        startListening()

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
        
        //searchController.searchBar.
        print(searchController.searchBar.text)
        
        searchController.searchBar.resignFirstResponder()
        
        self.wikiText = searchController.searchBar.text!
        
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
            cell.textLabel?.text = ""
        }
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        stopListening()
        var vc = segue.destinationViewController as! DisplayViewController
        var finalstr = wikiText.stringByReplacingOccurrencesOfString(" ", withString: "_")
        vc.articleName = (finalstr)
        vc.articleURL = ("https://en.wikipedia.org/wiki/" + (finalstr))
        vc.wiki = true
    }

    //Open Ears Code Starts
    
    //Code In the Beginning
    
    //End beginning code
    
    var lmPath: String!
    var dicPath: String!
    var words: Array<String> = []
    var currentWord: String!
    
    var kLevelUpdatesPerSecond = 18
    
    
    var openEarsEventsObserver = OEEventsObserver()
    var startupFailedDueToLackOfPermissions = Bool()
    
    
    func loadOpenEars() {
        
        startedListening = true
        
        self.openEarsEventsObserver = OEEventsObserver()
        self.openEarsEventsObserver.delegate = self
    
        
        var lmGenerator: OELanguageModelGenerator = OELanguageModelGenerator()
        
        addWords()
        var name = "LanguageModelFileStarSaver"
        lmGenerator.generateLanguageModelFromArray(words, withFilesNamed: name, forAcousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"))
        
        lmPath = lmGenerator.pathToSuccessfullyGeneratedLanguageModelWithRequestedName(name)
        dicPath = lmGenerator.pathToSuccessfullyGeneratedDictionaryWithRequestedName(name)
    }
    
    
    func pocketsphinxDidChangeLanguageModelToFile(newLanguageModelPathAsString: String, newDictionaryPathAsString: String) {
        print("Pocketsphinx is now using the following language model: \(newLanguageModelPathAsString) and the following dictionary: \(newDictionaryPathAsString)")
    }
    
    func pocketSphinxContinuousSetupDidFailWithReason(reasonForFailure: String) {
        print("Listening setup wasn't successful and returned the failure reason: \(reasonForFailure)")
    }
    
    func pocketSphinxContinuousTeardownDidFailWithReason(reasonForFailure: String) {
        print("Listening teardown wasn't successful and returned the failure reason: \(reasonForFailure)")
        
    }
    
    func testRecognitionCompleted() {
        print("A test file that was submitted for recognition is now complete.")
    }
    
    func startListening() {
        do{
            try OEPocketsphinxController.sharedInstance().setActive(true)}
        catch _ {
            print("error")
            print("asdasdasd")
        }
        OEPocketsphinxController.sharedInstance().startListeningWithLanguageModelAtPath(lmPath, dictionaryAtPath: dicPath, acousticModelAtPath: OEAcousticModel.pathToModel("AcousticModelEnglish"), languageModelIsJSGF: false)
    }
    
    func stopListening() {
        startedListening = false
        OEPocketsphinxController.sharedInstance().stopListening()
    }
    
    func addWords() {
        //add any thing here that you want to be recognized. Must be in capital letters
        words.append("GOBACK")
        //words.append("HOME")
    }
    
    
    func pocketsphinxFailedNoMicPermissions() {
        
        NSLog("Local callback: The user has never set mic permissions or denied permission to this app's mic, so listening will not start.")
        self.startupFailedDueToLackOfPermissions = true
        if OEPocketsphinxController.sharedInstance().isListening {
            var error = OEPocketsphinxController.sharedInstance().stopListening() // Stop listening if we are listening.
            if(error != nil) {
                NSLog("Error while stopping listening in micPermissionCheckCompleted: %@", error);
            }
        }
    }
    
    func pocketsphinxDidReceiveHypothesis(hypothesis: String!, recognitionScore: String!, utteranceID: String!) {
        
        print(hypothesis)
        
        if hypothesis == "GOBACK" {
            navigationController?.popViewControllerAnimated(true)
        }
        
        else if hypothesis == "HOME" {
            navigationController?.popToRootViewControllerAnimated(true)
        }
        
        else {
        
        wikiText = hypothesis
        
        performSegueWithIdentifier("gowiki", sender: self)
            
        }
        
    }


}
