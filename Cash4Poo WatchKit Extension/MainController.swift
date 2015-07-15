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
    @IBOutlet weak var btnSave: WKInterfaceButton!
    @IBOutlet weak var grpNoSettings: WKInterfaceGroup!
    @IBOutlet weak var grpMain: WKInterfaceGroup!

    var pooWatch: PooWatch?
    var userData: NSUserDefaults?
    var stopShouldReset:Bool = false


    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        self.userData = NSUserDefaults(suiteName: "group.cash4poo")

        // check settings
        if (self.userData!.objectForKey("annualSalary") == nil ||
            self.userData!.objectForKey("workHours") == nil)
        {
            self.grpNoSettings.setHidden(false)
            self.grpMain.setHidden(true)
        }
        else
        {
            self.grpNoSettings.setHidden(true)
            self.grpMain.setHidden(false)
        }
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

    func savePoopSession()
    {
        if (self.session != nil)
        {
            println(self.session!)

            var newHistory: [[String:String]]

            if let history = self.userData?.arrayForKey("history") as? [[String:String]]
            {
                newHistory = history
                newHistory.append(self.session!)

                println(newHistory)
            }
            else
            {
                newHistory = [self.session!]
            }

            println(newHistory)

            self.userData?.setObject([self.session!], forKey: "history")
            self.userData?.synchronize()
        }
    }



    // PooWatch tick, update labels
    func pooTick(elapsedTime: NSTimeInterval, elapsedTimeString: String)
    {
        let grossProfit = self.calculateGrossProfit(elapsedTime)
        let formatter = NSNumberFormatter()

        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 2

        self.lblStopwatch.setText(elapsedTimeString)
        self.lblGrossProfit.setText("\(formatter.stringFromNumber(grossProfit!)!)")

        self.session = ["\(elapsedTime)":"\(grossProfit)"]
    }

    func calculateGrossProfit(elapsedTime: NSTimeInterval) -> Double?
    {
        let annualSalary = self.userData?.integerForKey("annualSalary")
        let workHours = self.userData?.integerForKey("workHours")

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
