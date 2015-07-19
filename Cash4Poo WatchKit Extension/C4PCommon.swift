//
//  C4PCommon.swift
//  Cash4Poo
//
//  Created by brandon on 7/19/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit

class C4PCommon
{
    static let sharedInstance = C4PCommon()
    let appGroup              = "group.cash4poo"
    let numberFormatter       = NSNumberFormatter()
    let dateFormatter         = NSDateFormatter()

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
        // todo: dont have a global userData,
        // juist load settings here and set them to instance properties
        self.userData = NSUserDefaults(suiteName: self.appGroup)
    }

    func saveUserDefaults()
    {

    }

    private init()
    {
        println("init C4PCommon")
        self.loadData()
        self.defaultFormatters()
    }
}
