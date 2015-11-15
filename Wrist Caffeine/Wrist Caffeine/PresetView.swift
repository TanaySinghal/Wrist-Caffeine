//
//  PresetView.swift
//  Wrist Caffeine
//
//  Created by Tanay Singhal on 11/14/15.
//  Copyright © 2015 Tanay. All rights reserved.
//

import UIKit

var presets = [
    //minSensitivity --> less means less movement to stay awake
    //minSensitivity --> amount of movement needed to be considered awake
    PresetClass(name: "Homework", minSensitivity: 12, time1: 10, time2: 5),
    PresetClass(name: "Driving", minSensitivity: 10, time1: 5, time2: 5),
    PresetClass(name: "Class", minSensitivity: 8, time1: 20, time2: 10),
    PresetClass(name: "Walking", minSensitivity: 30, time1: 10, time2: 5),
    PresetClass(name: "Running", minSensitivity: 60, time1: 5, time2: 5)
]

class PresetView: UITableViewController {
    
    var newPreset = PresetClass(name: "", minSensitivity: 5, time1: 60, time2: 120)
    var presetToPass = PresetClass(name: "", minSensitivity: 5, time1: 60, time2: 120)
    
    //var vc: DetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //vc = DetailViewController()
        //vc = nil
        
        //if received new preset is not empty, add it
        if newPreset._name != "" {
            //print(newPreset._moveSensitivity)
            print(NSString(format: "Name: %@ \nSensitivity: %0.1f \nTime1: %0.1f \nTime2: %0.1f", newPreset._name, newPreset._moveSensitivity, newPreset._time1, newPreset._time2))
            presets.append(newPreset)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Preset", forIndexPath: indexPath)  
        
        //let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = presets[indexPath.row]._name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let row = tableView.indexPathForSelectedRow!.row;
        
        presetToPass = presets[row]
        print(presetToPass._name)
        
        performSegueWithIdentifier("DetailView", sender: self)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "DetailView") {
            //Send variable over
            let vc = segue.destinationViewController as! DetailViewController
            vc.configuration = presetToPass
            
        }
    }

}

class PresetClass {
    var _name = ""
    var _moveSensitivity = 0.0
    var _time1 = 0.0
    var _time2 = 0.0
    
    init(name: String, minSensitivity: Double, time1: Double, time2: Double) {
        _name = name
        _moveSensitivity = minSensitivity
        _time1 = time1
        _time2 = time2
    }
}

