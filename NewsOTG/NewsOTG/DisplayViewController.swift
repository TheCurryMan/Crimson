//
//  DisplayViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/23/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit
import AVFoundation

class DisplayViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    
    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var articleContent: UILabel!
    var articleName = ""
    var articleURL = ""
    var articleText = ""
    
    @IBOutlet var btnStop: UIButton!
    
    @IBOutlet var btnSpeak: UIButton!
    
    @IBOutlet var btnPause: UIButton!
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    @IBOutlet var pvSpeechProgress: UIProgressView!
    
    
    
    //var synth = AVSpeechSynthesizer()
    //var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        speechSynthesizer.delegate = self
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        // Do any additional setup after loading the view.
        
        articleTitle.text = articleName
        
        articleContent.text = "This is a very long paragraph. \n Very, very, very long. \n You better know who you're dealing with before you start playing this paragraph. "
        
        print(articleURL)
        
        
        let url = NSURL(string: articleURL)
        
        
    
        
        
        if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                
                let urlError = false
                
                
                
                if error == nil {
                    
                    
                    
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                    
                    /*
                    
                    var nounArray = [""]
                    
                    
                    var urlContentArray2 = urlContent.componentsSeparatedByString("false\">")
                    
                    urlContentArray2.removeAtIndex(0)
                    
                    var arr3 = [""]
                    arr3.removeAtIndex(0)
                    
                    for i in urlContentArray2 {
                        
                        var arr3 = i.componentsSeparatedByString("</guid>")
                        self.articlesURL.append(arr3[0])
                        
                        
                    }
                    
*/
                    
                   
                    var urlContentArray = urlContent.componentsSeparatedByString("el-editorial-source\">")
                    
                    urlContentArray.removeAtIndex(0)
                    
                    print(urlContentArray.count)
                    
                    if urlContentArray != [] {
                    
                  
                    
                    var finalContent = urlContentArray[0].componentsSeparatedByString("<p class=\"zn-body__paragraph zn-body__footer\">")
                    
                    
                    
                    finalContent.removeAtIndex(1)
                    
                    var finalStr = finalContent[0]
                    
                    let str = finalStr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                    
                    print(str)
                    
                    self.articleText = str
                    }
                        
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if urlError == true {
                            
                            print("error")
                            
                        } else {
                            
                            print("no error")
                            
                            print("Why isnt this working")
                            
                            self.articleContent.text = self.articleText

                        }
                        
                        
                        
                    }
                }
                
            })
            
            task.resume()
            
            
        }
        
        
    }
    
    var rate : Float!
    var pitch : Float!
    var volume : Float!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<String, AnyObject> = ["rate": rate, "pitch": pitch, "volume": volume]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
        
    }
   
    func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float {
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as! Float
            volume = userDefaults.valueForKey("volume") as! Float
            
            return true
        }
        
        return false
    }
    
    func animateActionButtonAppearance(shouldHideSpeakButton: Bool) {
        var speakButtonAlphaValue: CGFloat = 1.0
        var pauseStopButtonsAlphaValue: CGFloat = 0.0
        
        if shouldHideSpeakButton {
            speakButtonAlphaValue = 0.0
            pauseStopButtonsAlphaValue = 1.0
        }
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.btnSpeak.alpha = speakButtonAlphaValue
            
            self.btnPause.alpha = pauseStopButtonsAlphaValue
            
            self.btnStop.alpha = pauseStopButtonsAlphaValue
            
            self.pvSpeechProgress.alpha = pauseStopButtonsAlphaValue
        })
    }
    
    @IBAction func speak(sender: AnyObject) {
        if !speechSynthesizer.speaking {
            let textParagraphs = articleContent.text!.componentsSeparatedByString("\n")
            
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0
            
            for pieceOfText in textParagraphs {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.01
                totalTextLength = totalTextLength + pieceOfText.characters.count
                speechSynthesizer.speakUtterance(speechUtterance)
            }
            
            
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
        
        animateActionButtonAppearance(true)
    }
    
    
    
    @IBAction func stopSpeech(sender: AnyObject) {
        speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
          animateActionButtonAppearance(false)
    }
    
    @IBAction func pauseSpeech(sender: AnyObject) {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
          animateActionButtonAppearance(false)
       
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance: AVSpeechUtterance!) {
        currentUtterance = currentUtterance + 1
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!) {
        spokenTextLengths = spokenTextLengths + utterance.speechString.characters.count + 1
       
        let progress:Float = (Float(spokenTextLengths) / Float(totalTextLength))
        pvSpeechProgress.progress = progress
        
        if currentUtterance == totalUtterances {
            animateActionButtonAppearance(false)
        }    
    }
  
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        let progress: Float = Float(spokenTextLengths + characterRange.location) * 100 / Float(totalTextLength)
        pvSpeechProgress.progress = progress / 100
    }
   
    
/*
    
    @IBAction func textToSpeech(sender: UIButton) {
        
        myUtterance = AVSpeechUtterance(string: self.articleText)
        myUtterance.rate = 0.5
        synth.speakUtterance(myUtterance)
        
        
    }
    
    @IBAction func pauseSpeech(sender: UIButton) {
        synth.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        print(sender.value)
        myUtterance.rate = sender.value
        synth.continueSpeaking()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
