//
//  DisplayViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/23/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
}

func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
    var buffer = [T]()
    var added = Set<T>()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
}

import UIKit
import AVFoundation
import WatsonDeveloperCloud

class DisplayViewController: UIViewController, AVSpeechSynthesizerDelegate, SettingsViewControllerDelegate, AVAudioPlayerDelegate, OEEventsObserverDelegate
 {
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var articleContent: UITextView!
    var articleName = ""
    var articleURL = ""
    var articleText = ""
    var accent = ""
    
    @IBOutlet var btnStop: UIButton!
    
    @IBOutlet var btnSpeak: UIButton!
    
    @IBOutlet var btnPause: UIButton!
    
    @IBOutlet var btnRewind: UIButton!
    
    @IBOutlet var btnForward: UIButton!
    
    var totalTime = 0
    
    var currentTime = 0
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    var newVersion = true
    
    var content = ""
    
    var counter = 0
    
    var counter1 = 0
    
    var counterForArticle = 0
    
    var listOfArticles = [""]
    
    var listOfUrls = [""]
    
    var all = false
    
    var multiple = false
    
    var pause = false
    
    var listOfData : [NSData] = []
    
    var audioData : NSData = NSData()
    
    var startedPlaying = false
    
    var listOfText : [String] = []
    
    var wiki = false
    
    var convertedStrings = [""]
    
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet var pvSpeechProgress: UIProgressView!
    
    var previousSelectedRange: NSRange!
    
    let service = TextToSpeech(username: "d508639e-a16e-4153-a20e-bae38e58bd11", password: "wwGhyI4Vpbes")

    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    //var synth = AVSpeechSynthesizer()
    //var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewWillDisappear(animated: Bool) {
        print("View had disappeared!")
        if startedPlaying == true {
            audioPlayer.stop()

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        loadOpenEars()
        
        startListening()
        
        if startedPlaying == true {
            audioPlayer.stop()
            print("Audio Player should stop")
            counter = 0
            startedPlaying = false
            listOfData = []
        }
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        print(all)
        
        print(listOfArticles)
        
        
        
        speechSynthesizer.delegate = self
        
        let userDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
        
        if var i = userDefaults.valueForKey("accent") {
            accent = userDefaults.valueForKey("accent") as! String
        }
        
        else {accent = ""}
        
        if listOfArticles != [""] {
            all = true
            viewDidLoad()
        }
        
        
        
        
        
        print(self.rate)
        
        getData(content)
        
    }
    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = NSURL()
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 100))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        activityIndicator.color = UIColor.blackColor()
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        
        counter = 0
        
        print(all)
        
        if listOfArticles == [""] {
        
            articleTitle.text = articleName
        
            url = NSURL(string: articleURL)!}
        
        else {
            self.all = true
            
            print(listOfArticles)
            
            articleTitle.text = listOfArticles[counterForArticle]
            
            url = NSURL(string: listOfUrls[counterForArticle])!
            
        }
        
        articleContent.text = "Loading Content... "
        
        print(articleURL)
        
        
        
        
        print(url)
    
        
        
        //if url != nil {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                let urlError = false
                
                print("a")
                
                if error == nil {
                    
                    print("b")
                    
                    let urlContent = NSString(data: data!, encoding: NSUTF8StringEncoding) as NSString!
                    
                    
                    if self.wiki == false {
                    
                   
                    var urlContentArray = urlContent.componentsSeparatedByString("el-editorial-source\">")
                    
                    urlContentArray.removeAtIndex(0)
                    
                    
                    
                    
                    if urlContentArray != [] {
                    
                        print("Step 3")
                    
                        var finalContent = urlContentArray[0].componentsSeparatedByString("<p class=\"zn-body__paragraph zn-body__footer\">")
                    
                        print("Step 4")
                        
                        finalContent.removeAtIndex(1)
                        
                        print("step 5")
                    
                        var finalStr = finalContent[0]
                        print ("Step6")
                        
                        //print(finalStr)
                        
                        let finalStr2 = finalStr.stringByReplacingOccurrencesOfString("{([^}]*)}", withString: "")
                        
                        print(finalStr2)
                        
                        let newstr = finalStr2.stringByReplacingOccurrencesOfString("<script(.+?)*</script>", withString: "")
                        print("step 7")
                        
                        let str = newstr.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                    
                        print("Step 8")
                        
                        print(str)
                    
                        self.articleText = str.stringByReplacingOccurrencesOfString(".", withString: ". ")
                        }
                        
                    
                    }
                    
                    else {
                        
                        var wikiContent = urlContent.componentsSeparatedByString("<p></p>")
                        
                        var wikiHTML = wikiContent[0]
                        
                        var wikiPtags = wikiHTML.componentsSeparatedByString("<p>")
                        
                        var finalWiki : [String] = [""]
                        
                        for i in wikiPtags {
                            if i[i.startIndex] != "<" || i[0...1] == "<b"{
                                print("This is the wiki paragraph: \n\n\n\n")
                                print(i)
                                finalWiki.append(i)
                            }
                        }
                        
                        var wikiString = ""
                        
                        for i in finalWiki {
                            var str = i.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            str = str.stringByReplacingOccurrencesOfString("{([^}]*)}", withString: "")
                
                            wikiString = wikiString + str
                        }
                        
                        self.articleText = wikiString
                        
                    }
                        
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        if urlError == true {
                            
                            print("error")
                            
                        } else {
                            
                            //print("no error")
                            
                           // print("Why isnt this working")
                            
                           // print(self.articleText)
                            
                            
                            
                            self.articleContent.hidden = true
                            
                            self.articleContent.text = self.articleText
                            
                            if self.articleContent.text == ""{
                                self.viewDidLoad()
                            }
                            
                            print(self.articleText)
                            
                            self.setInitialFontAttribute()
                            
                            self.content = self.articleContent.text!
                            self.content = self.content.stringByReplacingOccurrencesOfString(".", withString: ". ")
                            print("\n \n \n \n \n \n This is the article")
                            print(self.content)
                            self.getData(self.content)
                        }}}})
            
            task.resume()}
    
    func getData(content:String) {
        
        listOfData = []
        counter1 = 0
        
        var listOfStrings = content.componentsSeparatedByString(".")
        print(listOfStrings)
        listOfStrings.removeLast()
        listOfText = listOfStrings
        self.activityIndicator.stopAnimating()
        self.articleContent.hidden = false
        
        print(listOfData)
        print(convertedStrings)
        getAudioData()
            }
        
        
        func getAudioData() {
            
            do {
                
                
                var i = listOfText[counter1]
                
                
                self.service.synthesize(i, voice: self.accent, completionHandler: {data, error in
                    print("THIS IS THE ACCENT: " + self.accent)
                    
                        print("Line converting: " + i)
                    
                    
                    if data != nil {
                        
                        self.listOfData.append(data!)
                        if self.counter1 < self.listOfText.count - 1 {
                            self.counter1 = self.counter1 + 1
                            self.convertedStrings.append(i)
                            print("Converted strings so far.... \n\n\n")
                            print(self.convertedStrings)
                            self.getAudioData()
                        }
                        
                    }})
                self.pvSpeechProgress.setProgress(0.0, animated: false)
            }
        catch {
            self.btnSpeak.enabled = false
            self.btnRewind.enabled = false
            self.btnForward.enabled = false
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
            
            print("THIS is the rate \n")
            print(rate)
            
            if var i = userDefaults.valueForKey("accent") {
                accent = userDefaults.valueForKey("accent") as! String
            }
                
            else {accent = ""}
            print("SKDLSKDJLSDJLKSDJ \n\n\n\n\n\n THIS SHOULD WORK")
            print(accent)
            getData(content)
            
            
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
        listOfData = uniq(listOfData)
        
        print(speechSynthesizer.speaking)
        
        print(sender)
        
        print("Value of bar: " + String(Float((counter+1)/(listOfText.count))))
        
        self.pvSpeechProgress.setProgress(Float(counter+1)/Float(listOfText.count), animated: true)
        
        //print(listOfData)
        print(listOfData.count)
        print("THE LENGTH OF THE ARRAY OF DATA IS ABOVE \n\n\n\n\n\n\n")
        
        if sender as! NSObject == btnSpeak as! NSObject &&  pause == true && startedPlaying == true{
            self.pauseSpeech(self)
        }
        
        else {
        
        if pause == false {
            btnSpeak.setImage(UIImage(named: "pause1"), forState: .Normal)
            pause = true }
        
        print(startedPlaying)
        
        if startedPlaying == false {playAudio()}
            
        else if startedPlaying == true {audioPlayer.play()}
            
        else {
        
        if !speechSynthesizer.speaking {
            let textParagraphs = articleContent.text!.componentsSeparatedByString(". ")
            
            totalUtterances = textParagraphs.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0
            
            print("Should play audio")
            
            for pieceOfText in textParagraphs {
            
                print(articleContent.text)
                
            //print(data)
            let speechUtterance = AVSpeechUtterance(string: pieceOfText)
            speechUtterance.rate = self.rate
            speechUtterance.pitchMultiplier = self.pitch
            speechUtterance.volume = 0.5
            speechUtterance.postUtteranceDelay = 0.002
            self.totalTextLength = self.totalTextLength + pieceOfText.characters.count
            self.speechSynthesizer.speakUtterance(speechUtterance)

            
            }
            
            
        }
            
            
        else{
            
            speechSynthesizer.continueSpeaking()
            self.audioPlayer.play()
        }
            
        }
            
        }
        
        
        
        
        
        //animateActionButtonAppearance(true)
            
            
    }
    
    func audioPlayerDidFinishPlaying( audioPlayer: AVAudioPlayer,
        successfully flag: Bool) {
            if counter < listOfData.count - 1 && all == false{
                
            
            counter = counter + 1
            startedPlaying = false
            speak(self)
            }
            
            else {
                if all == false {
                pauseSpeech(self)
                counter = 0
                    startedPlaying = false }
                else {
                    if counterForArticle < listOfArticles.count - 1 {
                    counterForArticle = counterForArticle + 1
                    counter = 0
                    startedPlaying = false
                    self.audioPlayer.stop()
                    listOfData = []
                    listOfText = [""]
                        btnSpeak.setImage(UIImage(named: "play1"), forState: .Normal)

                    viewDidLoad()
                    }
                    else {
                        all = false
                        pauseSpeech(self)
                    }
                }
            }
            
    }
    
    func playAudio() {
        

        do {
            //print(listOfData)
            
            print("This is the counter: \n\n\n" + String(counter))
            
          var i = listOfData[counter]
                //print(i)
            
            //print("playAudio function")
        
        self.audioPlayer = try AVAudioPlayer(data:i)
        self.audioPlayer.prepareToPlay()
        self.audioPlayer.delegate = self
        self.audioPlayer.enableRate = true
        self.audioPlayer.volume = self.volume
        self.audioPlayer.rate = self.rate
        self.audioPlayer.play()
        self.startedPlaying = true
            }
        
        catch {
            print("Error!")
        }
    }
    
    @IBAction func pauseSpeech(sender: AnyObject) {
        
        //pause = true
        if newVersion{
            btnSpeak.setImage(UIImage(named: "play1"), forState: .Normal)
            pause = false
            self.audioPlayer.pause()
            //animateActionButtonAppearance(false)
        } else {
        speechSynthesizer.pauseSpeakingAtBoundary(AVSpeechBoundary.Immediate)
          animateActionButtonAppearance(false)
        }
        
      
    }
    
    
    @IBAction func forward(sender: AnyObject) {
        pauseSpeech(self)
        if counter < listOfData.count-1{
            counter = counter + 1
            startedPlaying = false
            speak(self)
        }
        
        else {
            counter = listOfData.count
            //pauseSpeech(self)
        }
        
        
    }
    
    
    @IBAction func rewind(sender: AnyObject) {
        pauseSpeech(self)
        if counter > 0 {
            counter = counter - 1
            startedPlaying = false
            speak(self)
        }
        else {
            counter = 0
            audioPlayer.stop()
            startedPlaying = false
            //pauseSpeech(self)
        }
        
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        stopListening()
        if startedPlaying == true {
            audioPlayer.stop() }
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
        words.append("PLAY")
        words.append("PAUSE")
        words.append("BACK")
        words.append("HOME")
        words.append("SETTINGS")
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
        
        
        if hypothesis == "PLAY"{
            speak(self)
        }
            
        else if hypothesis == "PAUSE"{
            pauseSpeech(self)
            
        }
        else if hypothesis == "GOBACK" {
            navigationController?.popViewControllerAnimated(true)
            
        }
            
        else if hypothesis == "AUDIOREWIND" {
            rewind(self)
        }
            
        else if hypothesis == "AUDIOFORWARD" {
            forward(self)
        }
        
        else if hypothesis == "GOHOME" {
            
        }
        
        else if hypothesis == "SETTINGS" {
                print("Settings")
                //TODO - ADD SETTINGS COMMAND
        }
    }

    
    
    
    
    
    
    
    
    
    //CODE WE REALLY DON'T CARE ABOUT AND WILL BE REMOVED SOON ->
   
    
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
        accent = settings.valueForKey("accent") as! String
    }
    
    func setInitialFontAttribute() {
        let rangeOfWholeText = NSMakeRange(0, articleContent.text!.characters.count)
        let attributedText = NSMutableAttributedString(string: articleContent.text!)
        
        attributedText.addAttribute(NSFontAttributeName, value: UIFont(name: "Avenir", size: 16.0)!, range: rangeOfWholeText)
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

   
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "idSegueSettings" {
            let settingsViewController = segue.destinationViewController as! SettingsViewController
            settingsViewController.delegate = self
        }    
    }
    
    

}
