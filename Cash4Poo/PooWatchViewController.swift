//
//  ViewController.swift
//  Cash4Poo
//
//  Created by brandon on 7/1/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import UIKit

func timeIntervalToString(ti: NSTimeInterval) -> String? {
    let dcf = NSDateComponentsFormatter()
    dcf.zeroFormattingBehavior = .Pad
    dcf.allowedUnits = (.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitNanosecond)
    return dcf.stringFromTimeInterval(ti)
}

public struct StopWatch {
    private var startTime: NSDate?
    private var accumulatedTime: NSTimeInterval = 0.0
    
    public var elapsedTimeInterval: NSTimeInterval {
        get {
            return self.accumulatedTime + NSDate().timeIntervalSinceDate(self.startTime ?? NSDate())
        }
    }
    
    public var elapsedTimeString: String {
        get {
            return timeIntervalToString(self.elapsedTimeInterval) ?? "00:00:00"
        }
    }
    
    public mutating func start() {
        self.startTime = NSDate()
    }
    
    public mutating func stop() {
        self.accumulatedTime += NSDate().timeIntervalSinceDate(self.startTime ?? NSDate())
        self.startTime = nil
    }
    
    public mutating func reset() {
        self.accumulatedTime = 0.0
        self.start()
    }
}









class PooWatchViewController: UIViewController {
    @IBOutlet weak var lblStopwatch: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    var startTime = NSTimeInterval()
    
    var stopWatch: StopWatch = StopWatch()
    var timer: NSTimer?
    var stopShouldReset: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func updatePoopUI()
    {
        self.lblStopwatch.text = self.stopWatch.elapsedTimeString
        print("updatePoopUI()\n")
    }


    @IBAction func startPooping(sender: UIButton)
    {
        print("tapped start button in main app\n")

        if (self.timer?.valid != true)
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(
                0.10,
                target: self,
                selector: "updatePoopUI",
                userInfo: nil,
                repeats: true
            )

            self.btnStart.enabled = false
            self.btnStop.enabled = true
            self.stopWatch.start()
        }
    }
    
    @IBAction func stopPooping(sender: UIButton)
    {
        print("tapped stop button in main app\n")
        self.stopWatch.stop()
        self.timer?.invalidate()
        self.btnStart.enabled = true
        
        if (self.stopShouldReset == false)
        {
            self.stopShouldReset = true
        }
        else
        {
            self.stopWatch.reset()
            self.stopShouldReset = false
            self.btnStop.enabled = false
            updatePoopUI()
        }
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
        
        self.lblStopwatch.text = "\(strMinutes):\(strSeconds):\(strFraction)"
    }
}

