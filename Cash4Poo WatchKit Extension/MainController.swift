//
//  InterfaceController.swift
//  Cash4Poo WatchKit Extension
//
//  Created by brandon on 7/1/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit

class PooWatch : NSObject
{
    private var label:WKInterfaceLabel
    private var timer: NSTimer?
    private var startTime: NSDate?
    
    init(stopwatch_label: WKInterfaceLabel)
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
        self.label.setText(self.elapsedTimeString)
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


class MainController: WKInterfaceController
{
    @IBOutlet weak var lblStopwatch: WKInterfaceLabel!
    @IBOutlet weak var lblGrossProfit: WKInterfaceLabel!
    @IBOutlet weak var btnStart: WKInterfaceButton!
    @IBOutlet weak var btnStop: WKInterfaceButton!


    var pooWatch: PooWatch?
    var settings: NSUserDefaults?
    var stopShouldReset:Bool = false


    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        self.settings = NSUserDefaults(suiteName: "group.cash4poo")
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


    func startPooping()
    {
        self.btnStart.setEnabled(false)
        self.btnStop.setEnabled(true)

        if (self.pooWatch == nil)
        {
            self.pooWatch = PooWatch(stopwatch_label: self.lblStopwatch)
        }

        self.pooWatch!.start()
    }

    func stopPooping()
    {
        self.pooWatch!.stop()
        self.btnStart.setEnabled(true)

        if (self.stopShouldReset == false)
        {
            self.stopShouldReset = true
            self.btnStop.setTitle("Reset")
        }
        else
        {
            self.pooWatch!.reset()
            self.stopShouldReset = false
            self.btnStop.setEnabled(false)
            self.btnStop.setTitle("Stop")
        }
    }

    func calculateGrossProfit()
    {
        // salary per week = annualSalary / 52
        // salary per hour = salary per week / workHours
        // salary per minute = salary per hour / 60
        // salary per second = salary per minute / 60
        let annualSalary = self.settings?.integerForKey("annualSalary")
        let workHours = self.settings?.integerForKey("workHours")

        let salaryPerWeek = annualSalary! / 52
        let salaryPerHour = salaryPerWeek / workHours!
        let salaryPerMinute = salaryPerHour / 60
        let salaryPerSecond = salaryPerMinute / 60

        // put this in update label method
        self.lblGrossProfit.setText("$\(salaryPerSecond)")
    }

    func updateGrossProfitLabel(label: String)
    {

    }







    // UI actions
    @IBAction func startButtonTapped()
    {
        self.startPooping()
    }

    @IBAction func stopButtonTapped()
    {
        self.stopPooping()
    }

    @IBAction func setAnnualSalary()
    {
        self.presentControllerWithName("WatchSettings", context: "annualSalary")
    }

    @IBAction func setWorkHours()
    {
        self.presentControllerWithName("WatchSettings", context: "workHours")
    }
}
