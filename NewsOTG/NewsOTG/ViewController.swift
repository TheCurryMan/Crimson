//
//  ViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/22/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit
import SpeechKit

class SourceTableViewCell : UITableViewCell {

    @IBOutlet var sourceButton : UIButton!
    

    
    @IBAction func sourceClick(sender: UIButton) {
        
        if sender.tag == 0 {
        
             NSNotificationCenter.defaultCenter().postNotificationName("Wiki", object: nil)
            
        }
        
        else if sender.tag == 1 {
            
            NSNotificationCenter.defaultCenter().postNotificationName("CNN", object: nil)
        
        }
        
        else if sender.tag == 2 {
        
            NSNotificationCenter.defaultCenter().postNotificationName("BBC", object: nil)
        
        }
        
        
    }

}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKTransactionDelegate,OEEventsObserverDelegate  {

    @IBOutlet var tableView: UITableView!
    
    var finalSource = ""
    
    var sources = ["Wikipedia", "CNN", "BBC"]
    
    //var session = SKSession()
    
    //var transaction = SKTransaction()
    
    
    
    /*SKTransaction* transaction = [session recognizeWithType:SKTransactionSpeechTypeDictation
    detection:SKTransactionEndOfSpeechDetectionShort
    language:@"eng-USA"
    delegate:self]; */

    
    
    override func viewWillAppear(animated: Bool) {
        //viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
      
        
        loadOpenEars()
        
        startListening()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"Wiki", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"CNN", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "methodOFReceivedNotication:", name:"BBC", object: nil)
        
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
            
            self.performSegueWithIdentifier("wiki", sender: self)
        
        }
    }
    
    //Open Ears Code Starts
    
    //Code In the Beginning
    
        //loadOpenEars()
    
        //startListening()
    
    //End beginning code
    
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
            words.append("OKAYBLARB")
            words.append("SELECTSEA")
            words.append("SELECTWIKIPEDIA")
            words.append("SELECTBEE")
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
                
                
            if hypothesis == "SELECTSEA"{
                
                finalSource = "CNN"
                
                self.performSegueWithIdentifier("articles", sender: self)

            }
            
            else if hypothesis == "SELECTBEE"{
                finalSource = "BBC"
                
                self.performSegueWithIdentifier("articles", sender: self)
            }
            
            else if hypothesis == "SELECTWIKIPEDIA" {
            
                finalSource = "Wiki"
                
                self.performSegueWithIdentifier("wiki", sender: self)
                
            }
        }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        stopListening()
        if segue.identifier == "articles" {
        
            var vc = segue.destinationViewController as! CategoriesViewController
            
            vc.source = finalSource
            
        }
    }
    


}

