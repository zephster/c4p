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
    private var startTime: NSTimeInterval!
    private var ticker: (NSTimeInterval, String) -> Void

    init(tickFunction tick: (NSTimeInterval, String) -> Void)
    {
        self.ticker = tick;
    }

    var elapsedTime: NSTimeInterval {
        get {
            // couldnt i just subtract starttime from current timestamp?
            // todo: do that
            let date = NSDate(timeIntervalSince1970: self.startTime ?? NSDate().timeIntervalSince1970)
            return NSDate().timeIntervalSinceDate(date)
        }
    }
    
    var elapsedTimeString: String {
        get {
            return self.timeIntervalToString(self.elapsedTime) ?? "0:00:00"
        }
    }

    // todo: use common class code
    // todo: also, make a common code class
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
            self.startTime = NSDate().timeIntervalSince1970

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
        // reset
        self.timer = nil
        self.startTime = nil

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
    var stopShouldReset:Bool = false
    var session: [String:String]?

    let c4p:C4PCommon = C4PCommon.sharedInstance


    override func willActivate()
    {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()

        // check settings
        if let annualSalary = self.c4p.annualSalary,
           let workHours = self.c4p.workHours
        {
            // all ready!
            self.grpNoSettings.setHidden(true)
            self.grpMain.setHidden(false)
        }
        else
        {
            // no settings found, show no settings screen
            self.grpNoSettings.setHidden(false)
            self.grpMain.setHidden(true)
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
            var newHistory: [[String:String]]

            if let history = self.c4p.pooHistory
            {
                newHistory = history
                newHistory.append(self.session!)
            }
            else
            {
                newHistory = [self.session!]
            }

            self.c4p.pooHistory = newHistory
            self.c4p.saveData()
        }
    }



    // PooWatch tick, update labels
    func pooTick(elapsedTime: NSTimeInterval, elapsedTimeString: String)
    {
        let grossProfit:Double = self.calculateGrossProfit(elapsedTime)
        let grossProfitString = self.c4p.getGrossProfitString("\(grossProfit)")

        self.lblStopwatch.setText(elapsedTimeString)
        self.lblGrossProfit.setText(grossProfitString)

        self.session = [
            "elapsedTime": "\(elapsedTime)",
            "grossProfit": "\(grossProfit)",
            "startTime"  : "\(self.pooWatch!.startTime)",
            "stopTime"   : "\(NSDate().timeIntervalSince1970)"
        ]
    }

    func calculateGrossProfit(elapsedTime: NSTimeInterval) -> Double
    {
        if let annualSalary = self.c4p.annualSalary,
            let workHours = self.c4p.workHours
        {
            let salaryPerSecond = Double(annualSalary) / 52 / Double(workHours) / 60 / 60
            let currentGrossProfit = salaryPerSecond * round(Double(elapsedTime))

            return currentGrossProfit
        }

        return 0
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

    @IBAction func saveButtonTapped() {
        self.savePoopSession()
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
