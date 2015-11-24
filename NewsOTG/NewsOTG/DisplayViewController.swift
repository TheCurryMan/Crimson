//
//  DisplayViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 11/23/15.
//  Copyright © 2015 Avinash Jain. All rights reserved.
//

import UIKit
import AVFoundation

class DisplayViewController: UIViewController {
    
    @IBOutlet var rateSlider: UISlider!
    
    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var articleContent: UILabel!
    var articleName = ""
    var articleURL = ""
    var articleText = ""
    var synth = AVSpeechSynthesizer()
    var myUtterance = AVSpeechUtterance(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("asdasdasdasdaddadasdasdasd")
        
        // Do any additional setup after loading the view.
        
        articleTitle.text = articleName
        
        print("HELLO")
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
