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

class CategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OEEventsObserverDelegate {
    @IBOutlet var tableView: UITableView!
    
    var source = ""
    
    var link = ""
    
    var categories = ["World", "Top Stories", "Tech", "Business", "Politics", "Health"]
    
    override func viewWillAppear(animated: Bool) {
        loadOpenEars()
        startListening()
        
    }

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
    
    // OPEN EARS CODE
    
    var lmPath: String!
    var dicPath: String!
    var words: Array<String> = []
    var currentWord: String!
    
    var kLevelUpdatesPerSecond = 18
    
    
    var openEarsEventsObserver = OEEventsObserver()
    var startupFailedDueToLackOfPermissions = Bool()
    
    
    
    func loadOpenEars() {
        
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
        OEPocketsphinxController.sharedInstance().stopListening()
    }
    
    func addWords() {
        //add any thing here that you want to be recognized. Must be in capital letters
        words.append("WORLD")
        words.append("TOP STORIES")
        words.append("TECH")
        words.append("BUSINESS")
        words.append("POLITICS")
        words.append("HEALTH")
        words.append("GO BACK")
        
        //["World", "Top Stories", "Tech", "Business", "Politics", "Health"]
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
        /*
        if hypothesis == "OKAYBLARB"{
        stopListening()
        performSegueWithIdentifier("hometovoice", sender: self)
        } */
        
        
        if hypothesis == "WORLD"{
            World(self)
        }
            
        else if hypothesis == "TOP STORIES"{
            topStories(self)
            
        }
        else if hypothesis == "TECH" {
            
            Tech(self)
        }
            
        else if hypothesis == "BUSINESS" {
            Business(self)
        }
            
        else if hypothesis == "POLITICS" {
            Politics(self)
        }
            
        else if hypothesis == "HEALTH" {
            Health(self)
        }
            
        else if hypothesis == "GO BACK" {
            navigationController?.popViewControllerAnimated(true)
        }
    }

    
    override func viewWillDisappear(animated: Bool) {
        stopListening()
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
