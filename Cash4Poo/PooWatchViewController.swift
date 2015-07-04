//
//  ViewController.swift
//  Cash4Poo
//
//  Created by brandon on 7/1/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import UIKit

class PooWatch : NSObject
{
    private var label:UILabel
    private var timer: NSTimer?
    private var startTime: NSDate?
    
    init(stopwatch_label: UILabel)
    {
        self.label = stopwatch_label
    }

    var elapsedTime: NSTimeInterval {
        get {
            return NSDate().timeIntervalSinceDate(self.startTime ?? NSDate())
        }
    }
    
    var elapsedTimeString: String {
        get {
            println(self.elapsedTime)
            return self.timeIntervalToString(self.elapsedTime) ?? "00:00:00"
        }
    }
    
    private func timeIntervalToString(interval: NSTimeInterval) -> String?
    {
        let dcf = NSDateComponentsFormatter()
        dcf.zeroFormattingBehavior = .Pad
        dcf.allowedUnits = (.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond)
        
        return dcf.stringFromTimeInterval(interval)
    }

    func start()
    {
        self.reset()
        
        if (self.timer?.valid != true)
        {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(
                1.0,
                target: self,
                selector: "updatePoopUI",
                userInfo: nil,
                repeats: true
            )
        }
    }

    func updatePoopUI()
    {
        self.label.text = self.elapsedTimeString
    }

    func stop()
    {
        self.timer?.invalidate()
    }

    func reset()
    {
        // reset timer
        self.timer = nil

        // reset startTime to 0:00:00
        self.startTime = NSDate()

        updatePoopUI()
    }
}







class PooWatchViewController: UIViewController {
    @IBOutlet weak var lblStopwatch: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    var pooWatch: PooWatch?
    var stopShouldReset:Bool = false

    @IBAction func startPooping(sender: UIButton)
    {
        self.btnStart.enabled = false
        self.btnStop.enabled = true

        if (self.pooWatch == nil)
        {
            self.pooWatch = PooWatch(stopwatch_label: self.lblStopwatch)
        }

        self.pooWatch!.start()
    }

    @IBAction func stopPooping(sender: UIButton)
    {
        self.pooWatch!.stop()
        self.btnStart.enabled = true
        
        if (self.stopShouldReset == false)
        {
            self.stopShouldReset = true
            self.btnStop.setTitle("Reset", forState: .Normal)
        }
        else
        {
            self.pooWatch!.reset()
            self.stopShouldReset = false
            self.btnStop.enabled = false
            self.btnStop.setTitle("Stop", forState: .Normal)
        }
    }




    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

