//
//  SettingsViewController.swift
//  NewsOTG
//
//  Created by Avinash Jain on 1/5/16.
//  Copyright © 2016 Avinash Jain. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func didSaveSettings()
}


class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbSettings: UITableView!
    
    
    var delegate: SettingsViewControllerDelegate!
    
    let speechSettings = NSUserDefaults.standardUserDefaults()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    
    var arrVoiceLanguages: [Dictionary<String, String>] = []
    
    var selectedVoiceLanguage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
        
        // Make self the delegate and datasource of the tableview.
        tbSettings.delegate = self
        tbSettings.dataSource = self
        
        // Make the table view with rounded contents.
        tbSettings.layer.cornerRadius = 15.0
        
        
        rate = speechSettings.valueForKey("rate") as! Float
        pitch = speechSettings.valueForKey("pitch") as! Float
        volume = speechSettings.valueForKey("volume") as! Float
        
        
        //prepareVoiceList()
        
        //println(AVSpeechSynthesisVoice.speechVoices())
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
    
    
    // MARK: UITableView method implementation
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row < 3 {
            cell = tableView.dequeueReusableCellWithIdentifier("idCellSlider", forIndexPath: indexPath) as UITableViewCell
            
            let keyLabel = cell.contentView.viewWithTag(10) as? UILabel
            let valueLabel = cell.contentView.viewWithTag(20) as? UILabel
            let slider = cell.contentView.viewWithTag(30) as! CustomSlider
            
            var value: Float = 0.0
            switch indexPath.row {
            case 0:
                value = rate
                
                keyLabel?.text = "Rate"
                valueLabel?.text = NSString(format: "%.2f", rate) as String
                slider.minimumValue = AVSpeechUtteranceMinimumSpeechRate
                slider.maximumValue = AVSpeechUtteranceMaximumSpeechRate
                slider.addTarget(self, action: "handleSliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
                slider.sliderIdentifier = 100
                
            case 1:
                value = pitch
                
                keyLabel?.text = "Pitch"
                valueLabel?.text = NSString(format: "%.2f", pitch) as String
                slider.minimumValue = 0.5
                slider.maximumValue = 2.0
                slider.addTarget(self, action: "handleSliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
                slider.sliderIdentifier = 200
                
            default:
                value = volume
                
                keyLabel?.text = "Volume"
                valueLabel?.text = NSString(format: "%.2f", volume) as String
                slider.minimumValue = 0.0
                slider.maximumValue = 1.0
                slider.addTarget(self, action: "handleSliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
                slider.sliderIdentifier = 300
            }
            
            
            if slider.value != value {
                slider.value = value
            }
        }/*
        else{
            cell = tableView.dequeueReusableCellWithIdentifier("idCellVoicePicker", forIndexPath: indexPath) as UITableViewCell
            
            let pickerView = cell.contentView.viewWithTag(10) as! UIPickerView
            pickerView.delegate = self
            pickerView.dataSource = self
        } */
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 3 {
            return 100.0
        }
        else{
            return 170.0
        }
    }
    
    
    // MARK: IBAction method implementation
    
    @IBAction func saveSettings(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setFloat(rate, forKey: "rate")
        NSUserDefaults.standardUserDefaults().setFloat(pitch, forKey: "pitch")
        NSUserDefaults.standardUserDefaults().setFloat(volume, forKey: "volume")
        //NSUserDefaults.standardUserDefaults().setObject(arrVoiceLanguages[selectedVoiceLanguage]["languageCode"], forKey: "languageCode")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.delegate.didSaveSettings()
        
        navigationController?.popViewControllerAnimated(true)

    }
    
    
    // MARK: Custom method implementation
    
    func handleSliderValueChange(sender: CustomSlider) {
        
        switch sender.sliderIdentifier {
        case 100:
            rate = sender.value
            
        case 200:
            pitch = sender.value
            
        default:
            volume = sender.value
        }
        
        tbSettings.reloadData()
    }
    /*
    
    func prepareVoiceList() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            let voiceLanguageCode = (voice as AVSpeechSynthesisVoice).language
            
            let languageName = NSLocale.currentLocale().displayNameForKey(NSLocaleIdentifier, value: voiceLanguageCode)!
            
            let dictionary = ["languageName": languageName, "languageCode": voiceLanguageCode]
            
            arrVoiceLanguages.append(dictionary)
        }
    }
    
    
    */
    // MARK: UIPickerView method implementation
    
  /*  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrVoiceLanguages.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        let voiceLanguagesDictionary = arrVoiceLanguages[row] as Dictionary<String, String>
        
        return voiceLanguagesDictionary["languageName"]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVoiceLanguage = row
    } */
    
}

