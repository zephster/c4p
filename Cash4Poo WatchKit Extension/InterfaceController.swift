//
//  InterfaceController.swift
//  Cash4Poo WatchKit Extension
//
//  Created by brandon on 7/1/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
    @IBOutlet weak var lblStopwatch: WKInterfaceLabel!
    @IBOutlet weak var btnStart: WKInterfaceButton!
    @IBOutlet weak var btnStop: WKInterfaceButton!
    
    var timer = NSTimer()
    var startTime = NSTimeInterval()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func startPooping()
    {
        print("tapped start button in watch app\n")
        
        // start if timer is stopped
        if (!self.timer.valid)
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(
                0.1,
                target: self,
                selector: "poopTick",
                userInfo: nil,
                repeats: true
            )
            
            self.startTime = NSDate.timeIntervalSinceReferenceDate()
            
            self.btnStart.setEnabled(false)
        }
    }
    
    
    @IBAction func stopPooping()
    {
        print("tapped stop button in watch app\n")
        self.timer.invalidate()
        self.btnStart.setEnabled(true)
    }
    
    func poopTick()
    {
        var currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime = currentTime - self.startTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        self.lblStopwatch.setText("\(strMinutes):\(strSeconds):\(strFraction)")
    }

}
