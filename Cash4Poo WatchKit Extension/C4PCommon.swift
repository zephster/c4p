//
//  C4PCommon.swift
//  Cash4Poo
//
//  Created by brandon on 7/19/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import Foundation

class C4PCommon
{
    static let sharedInstance = C4PCommon()
    let appGroup              = "group.cash4poo"
    let numberFormatter       = NSNumberFormatter()
    let dateFormatter         = NSDateFormatter()

    var annualSalary:Int?
    var workHours:Int?
    var pooHistory: [[String:String]]?

    var userData: NSUserDefaults?


    func defaultFormatters()
    {
        self.numberFormatter.numberStyle           = .CurrencyStyle
        self.numberFormatter.maximumFractionDigits = 2

        self.dateFormatter.timeZone   = NSTimeZone(name: "UTC")
        self.dateFormatter.dateFormat = "HH:mm:ss"
    }

    func loadData()
    {
        self.userData = NSUserDefaults(suiteName: self.appGroup)

        self.annualSalary = self.userData?.integerForKey("annualSalary")
        self.workHours = self.userData?.integerForKey("workHours")
        self.pooHistory = self.userData?.arrayForKey("history") as? [[String:String]]
    }

    func saveData()
    {
        self.userData?.setObject(self.annualSalary, forKey: "annualSalary")
        self.userData?.setObject(self.workHours, forKey: "workHours")
        self.userData?.setObject(self.pooHistory, forKey: "history")
        self.userData?.synchronize()
    }


    func getGrossProfitString(profit: String) -> String
    {
        let grossProfit = self.stringToDouble(profit)
        return self.numberFormatter.stringFromNumber(grossProfit)!
    }

    func getTimeString(time: String) -> String
    {
        let timeInterval = self.stringToDouble(time)
        let timeDate = NSDate(timeIntervalSince1970: timeInterval)

        return self.dateFormatter.stringFromDate(timeDate)
    }


    func stringToDouble(input: String) -> Double
    {
        return (input as NSString).doubleValue
    }

    private init()
    {
        println("init C4PCommon")
        self.loadData()
        self.defaultFormatters()
    }
}
