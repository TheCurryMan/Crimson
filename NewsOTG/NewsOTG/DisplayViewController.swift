//
//  DisplayViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/23/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit
import AVFoundation


class DisplayViewController: UIViewController, AVSpeechSynthesizerDelegate, SettingsViewControllerDelegate
 {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var articleContent: UITextView!
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
    
    var previousSelectedRange: NSRange!
    
    //var synth = AVSpeechSynthesizer()
    //var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidAppear(animated: Bool) {
        
        speechSynthesizer.delegate = self
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
    }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        
        articleTitle.text = articleName
        
        articleContent.text = "Loading Content... "
        
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
                    let newstr = finalStr.stringByReplacingOccurrencesOfString("<script(.+?)*</script>", withString: "", options: .RegularExpressionSearch, range: nil)
                    let str = newstr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                    
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
                            
                            print(self.articleText)
                            
                            self.setInitialFontAttribute()

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
        print(speechSynthesizer.speaking)
        if !speechSynthesizer.speaking {
            let textParagraphs = articleContent.text!.componentsSeparatedByString(". ")
            
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0
            
            for pieceOfText in textParagraphs {
                let speechUtterance = AVSpeechUtterance(string: pieceOfText)
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.002
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
        
        unselectLastWord()
        previousSelectedRange = nil
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
        unselectLastWord()
        previousSelectedRange = nil
        if currentUtterance == totalUtterances {
            animateActionButtonAppearance(false)
            unselectLastWord()
            previousSelectedRange = nil
        }    
    }
  
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        
        mutableAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: characterRange)
        let progress: Float = Float(spokenTextLengths + characterRange.location) * 100 / Float(totalTextLength)
        pvSpeechProgress.progress = progress / 100
        
        articleContent.textStorage.beginEditing()
        
        // Determine the current range in the whole text (all utterances), not just the current one.
        let rangeInTotalText = NSMakeRange(spokenTextLengths + characterRange.location, characterRange.length)
        
        // Select the specified range in the textfield.
        articleContent.selectedRange = rangeInTotalText
        
        // Store temporarily the current font attribute of the selected text.
        let currentAttributes = articleContent.attributedText.attributesAtIndex(rangeInTotalText.location, effectiveRange: nil)
        let fontAttribute: AnyObject? = currentAttributes[NSFontAttributeName]
        
        // Assign the selected text to a mutable attributed string.
        let attributedString = NSMutableAttributedString(string: articleContent.attributedText.attributedSubstringFromRange(rangeInTotalText).string)
        
        
                // Make the text of the selected area orange by specifying a new attribute.
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: NSMakeRange(0, attributedString.length))
            
            // Make sure that the text will keep the original font by setting it as an attribute.
            attributedString.addAttribute(NSFontAttributeName, value: fontAttribute!, range: NSMakeRange(0, attributedString.string.characters.count))
        articleContent.scrollRangeToVisible(rangeInTotalText)
    
        
        
        
        
        // Replace the selected text with the new one having the orange color attribute.
        articleContent.textStorage.replaceCharactersInRange(rangeInTotalText, withAttributedString: attributedString)
        
        // If there was another highlighted word previously (orange text color), then do exactly the same things as above and change the foreground color to black.
        if let previousRange = previousSelectedRange {
            let previousAttributedText = NSMutableAttributedString(string: articleContent.attributedText.attributedSubstringFromRange(previousRange).string)
            previousAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, previousAttributedText.length))
            previousAttributedText.addAttribute(NSFontAttributeName, value: fontAttribute!, range: NSMakeRange(0, previousAttributedText.length))
            
            articleContent.textStorage.replaceCharactersInRange(previousRange, withAttributedString: previousAttributedText)
            
            previousSelectedRange = rangeInTotalText
        }
        
        // End editing the text storage.
        articleContent.textStorage.endEditing()
    }
   
    @IBAction func settingsPressed(sender: AnyObject) {
        performSegueWithIdentifier("idSegueSettings", sender: self)
    }
    
    
    func didSaveSettings() {
        let settings = NSUserDefaults.standardUserDefaults() as NSUserDefaults!
        
        rate = settings.valueForKey("rate") as! Float
        pitch = settings.valueForKey("pitch") as! Float
        volume = settings.valueForKey("volume") as! Float
    }
    
    func setInitialFontAttribute() {
        let rangeOfWholeText = NSMakeRange(0, articleContent.text!.characters.count)
        let attributedText = NSMutableAttributedString(string: articleContent.text!)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 18.0)!, range: rangeOfWholeText)
        articleContent.textStorage.beginEditing()
        articleContent.textStorage.replaceCharactersInRange(rangeOfWholeText, withAttributedString: attributedText)
        articleContent.textStorage.endEditing()
    }
    
    func unselectLastWord() {
        if let selectedRange = previousSelectedRange {
            // Get the attributes of the last selected attributed word.
            let currentAttributes = articleContent.attributedText.attributesAtIndex(selectedRange.location, effectiveRange: nil)
            // Keep the font attribute.
            let fontAttribute: AnyObject? = currentAttributes[NSFontAttributeName]
            
            // Create a new mutable attributed string using the last selected word.
            let attributedWord = NSMutableAttributedString(string: articleContent.attributedText.attributedSubstringFromRange(selectedRange).string)
            
            // Set the previous font attribute, and make the foreground color black.
            attributedWord.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, attributedWord.length))
            attributedWord.addAttribute(NSFontAttributeName, value: fontAttribute!, range: NSMakeRange(0, attributedWord.length))
            
            // Update the text storage property and replace the last selected word with the new attributed string.
            articleContent.textStorage.beginEditing()
            articleContent.textStorage.replaceCharactersInRange(selectedRange, withAttributedString: attributedWord)
            articleContent.textStorage.endEditing()
        }
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
    
   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueSettings" {
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.delegate = self
        }    
    }

}
