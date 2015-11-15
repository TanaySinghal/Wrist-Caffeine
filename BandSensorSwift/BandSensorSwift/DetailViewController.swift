//
//  ViewController.swift
//  BandSensorSwift
//
//  Created by Mark Thistle on 4/7/15.
//  Copyright (c) 2015 New Thistle LLC. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, MSBClientManagerDelegate {


    @IBOutlet weak var txtOutput: UILabel!
    @IBOutlet weak var accelLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var NameLabel: UILabel!
    weak var client: MSBClient?
    
    var configuration = PresetClass(name: "", minSensitivity: 5, time1: 0, time2: 0)
    
    var timer = NSTimer()
    var counter = 0.0
    
    var time1HasBeenUsed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Welcome to detail view!")
        print(configuration._name)
        
        
        NameLabel.text = configuration._name
        
        // Do any additional setup after loading the view, typically from a nib.
        MSBClientManager.sharedManager().delegate = self
        
        if let client = MSBClientManager.sharedManager().attachedClients().first as? MSBClient {
            self.client = client
            MSBClientManager.sharedManager().connectClient(self.client)
            
            if (client.isDeviceConnected) {
                self.output("Band connected.")
                runExampleCode()
            }
            else {
                self.output("Please wait. Connecting to Band...")
            }
            
        } else {
            self.output("Failed! No Bands attached.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: if gyroscope mag is less than 10, start timer for alarm (time1 amount)
    //TOOD: else, stop and reset timer
    
    func startTimer() {
        //Start timer
        timerLabel.text = String(counter)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        print(counter)
        timerLabel.text = String(counter++)
        if counter > configuration._time1 && !time1HasBeenUsed {
            sendTwoVibrations()
            //print("Time1 has been used")
            time1HasBeenUsed = true
            timerLabel.textColor = UIColor.redColor()
        }
        
        if counter > configuration._time2+configuration._time1 && time1HasBeenUsed{
            sendAlarmVibration()
            stopAndResetTimer()
            //print("Time2 has been used")
            time1HasBeenUsed = false
        }
        
    }
    

    func stopAndResetTimer() {
        
        counter = 0
        timerLabel.text = String(counter)
        timerLabel.textColor = UIColor.blackColor()
    }
    
    
    func runExampleCode() {
        
        if let client = self.client {
            if client.isDeviceConnected == false {
                self.output("Band is not connected. Please wait....")
                return
            }
            do {
                //Begun timer
                self.startTimer()
                
                try client.sensorManager.startGyroscopeUpdatesToQueue(nil, withHandler: { (gyroscopeData: MSBSensorGyroData!, error: NSError!) -> Void in
                    
                    let gyroscopeMag = sqrt(pow(gyroscopeData.x,2) + pow(gyroscopeData.y,2) + pow(gyroscopeData.z,2))
                    //if we are moving too much (higher number is more movement)
                    if gyroscopeMag > self.configuration._moveSensitivity {
                        //reset timer
                        self.stopAndResetTimer()
                        //use first timer, since person has woken
                        self.time1HasBeenUsed = false
                        self.timerLabel.textColor = UIColor.blackColor()
                    }
                    self.accelLabel.text = NSString(format: "Gyro Data: %0.1f", gyroscopeMag) as String
                })
                
            } catch {
                print(error)
            }

        } else {
            self.output("Band is not connected. Please wait....")
        }
    }
    
    func stopUpdate() {
        if let client = self.client {
            if client.isDeviceConnected == false {
                self.output("Band is not connected. Please wait....")
                return
            }
            do {
                //Begun timer
                stopAndResetTimer()
                timer.invalidate()
                
                try client.sensorManager.stopGyroscopeUpdatesErrorRef()
                
            } catch {
                print(error)
            }
            
        } else {
            self.output("Band is not connected. Please wait....")
        }
    }
    @IBAction func didSelectSendHapticButton(sender: AnyObject) {
        print("haptic");
        if let band = self.client {
            band.notificationManager.vibrateWithType(MSBVibrationType.NotificationOneTone, completionHandler: {(error) in
                if error != nil {
                    print("Error vibrating device: \(error)")
                }
            })
        }
    }
    
    func sendTwoVibrations() {
        print("Sending two vibrations")
        if let band = self.client {
            band.notificationManager.vibrateWithType(MSBVibrationType.NotificationTwoTone, completionHandler: {(error) in
                if error != nil {
                    print("Error vibrating device: \(error)")
                }
            })
        }
    }
    
    func sendAlarmVibration() {
        print("Sending alarm vibration")
        if let band = self.client {
            band.notificationManager.vibrateWithType(MSBVibrationType.NotificationAlarm, completionHandler: {(error) in
                if error != nil {
                    print("Error vibrating device: \(error)")
                }
            })
        }

        
    }
    
    func output(message: String) {
        print(message)
        txtOutput.text = message
    }
    
    @IBAction func disconnectBand(sender: AnyObject) {
        if (!client!.isDeviceConnected) {
            return;
        }
        MSBClientManager.sharedManager().cancelClientConnection(client)
        client = nil
        
        //clientManager(MSBClientManager!, clientDidDisconnect: self.client)
    }
    
    // Mark - Client Manager Delegates
    func clientManager(clientManager: MSBClientManager!, clientDidConnect client: MSBClient!) {
        self.output("Band connected.")
        runExampleCode()
    }
    
    func clientManager(clientManager: MSBClientManager!, clientDidDisconnect client: MSBClient!) {
        self.output(")Band disconnected.")
    }
    
    func clientManager(clientManager: MSBClientManager!, client: MSBClient!, didFailToConnectWithError error: NSError!) {
        self.output("Failed to connect to Band.")
        self.output(error.description)
    }
    
    //Move segue
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Preparing for segue ")
        if(segue.identifier == "disconnectBack") {
            print("Disconnect back")
            if (!client!.isDeviceConnected) {
                return;
            }
            MSBClientManager.sharedManager().cancelClientConnection(client)
            client = nil
        }
    }*/
    
    override func viewWillDisappear(animated: Bool) {
        /*print("Disconnecting...")
        if (!client!.isDeviceConnected) {
            return;
        }
        MSBClientManager.sharedManager().cancelClientConnection(client)
        client = nil*/
        
        /*stopAndResetTimer()
        timer.invalidate()*/
        stopUpdate()
        

    }
}

