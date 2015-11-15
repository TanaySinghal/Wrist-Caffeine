//
//  AddPresetView.swift
//  Wrist Caffeine
//
//  Created by Tanay Singhal on 11/14/15.
//  Copyright © 2015 Tanay. All rights reserved.
//

import UIKit


class AddPresetView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var sensitivityLabel: UILabel!
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var sliderMinSensitivity: UISlider!
    @IBOutlet weak var sliderTime1: UISlider!
    @IBOutlet weak var sliderTime2: UISlider!
    
    
    @IBAction func moveSensitivityChange(sender: AnyObject) {
        
        let displayedValue = sliderMinSensitivity.value
        sensitivityLabel.text = String(format: "Movement Sensitivity: %0.1f deg/s", displayedValue)
    }
    
    @IBAction func time1Change(sender: AnyObject) {
        let displayedValue = sliderTime1.value
        time1Label.text = String(format: "Time before weak vibration: %0.1fs", displayedValue)
    }
    
    @IBAction func time2Change(sender: AnyObject) {
        let displayedValue = sliderTime2.value
        time2Label.text = String(format: "Time before strong vibration: %0.1fs", displayedValue)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get variable from sliders/text labels
        let newPresetName = name!.text!
        let newMinSensitivity = Double(sliderMinSensitivity.value)
        let newTime1 = Double(sliderTime1.value)
        let newTime2 = Double(sliderTime2.value)
        
        //Send variables to preset
        if segue.identifier == "AddPreset" {
            let varToSend = PresetClass(name: newPresetName, minSensitivity: newMinSensitivity, time1: newTime1, time2: newTime2)
            let destinationVC = segue.destinationViewController as! PresetView
            destinationVC.newPreset = varToSend
            
            
        }
    }
    
}