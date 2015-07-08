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
    private var timer: NSTimer?
    private var startTime: NSDate?
    private var ticker: (NSTimeInterval, String) -> Void

    init(tickFunction tick: (NSTimeInterval, String) -> Void)
    {
        self.ticker = tick;
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
                selector: "pooTick",
                userInfo: nil,
                repeats: true
            )
        }
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

        // update UI with a tick
        self.pooTick()
    }

    func pooTick()
    {
        self.ticker(self.elapsedTime, self.elapsedTimeString)
    }

    deinit
    {
        self.timer?.invalidate()
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
        // todo: dont reset timer state when stopping then re-starting
        self.btnStart.setEnabled(false)
        self.btnStop.setEnabled(true)

        if (self.pooWatch == nil)
        {
            self.pooWatch = PooWatch(tickFunction: self.pooTick)
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

    // PooWatch tick, update labels
    func pooTick(elapsedTime: NSTimeInterval, elapsedTimeString: String)
    {
        let grossProfit:Double = self.calculateGrossProfit(elapsedTime)

        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2

        self.lblStopwatch.setText(elapsedTimeString)
        self.lblGrossProfit.setText("\(formatter.stringFromNumber(grossProfit)!)")
    }

    func calculateGrossProfit(elapsedTime: NSTimeInterval) -> Double
    {
        let annualSalary = self.settings?.integerForKey("annualSalary")
        let workHours = self.settings?.integerForKey("workHours")

        // todo: make this math better
        // let salaryPerWeek = Double(annualSalary!) / 52
        // let salaryPerHour = salaryPerWeek / Double(workHours!)
        // let salaryPerMinute = salaryPerHour / 60
        // let salaryPerSecond = salaryPerMinute / 60
        let salaryPerSecond = Double(annualSalary!) / 52 / Double(workHours!) / 60 / 60
        let currentGrossProfit = salaryPerSecond * round(Double(elapsedTime))

        return currentGrossProfit
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
