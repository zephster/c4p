//
//  HistoryDetail.swift
//  Cash4Poo
//
//  Created by brandon on 7/15/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit

class HistoryDetailController: WKInterfaceController
{
    @IBOutlet weak var lblDate: WKInterfaceLabel!
    @IBOutlet weak var lblStart: WKInterfaceLabel!
    @IBOutlet weak var lblStop: WKInterfaceLabel!
    @IBOutlet weak var lblTime: WKInterfaceLabel!
    @IBOutlet weak var lblProfit: WKInterfaceLabel!
    @IBOutlet weak var btnDelete: WKInterfaceButton!


    var pooData: [String:String]?
    let nf = NSNumberFormatter()
    let df = NSDateFormatter()


    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        self.pooData = context! as? [String : String]

        self.nf.numberStyle = .CurrencyStyle
        self.nf.maximumFractionDigits = 2

        self.df.timeZone = NSTimeZone(name: "UTC")
        self.df.dateFormat = "HH:mm:ss"

        self.populateData()
    }


    func populateData()
    {
        // profit
        let grossProfit:Double = (self.pooData!["grossProfit"]! as NSString).doubleValue
        self.lblProfit.setText(self.nf.stringFromNumber(grossProfit))

        // elapsed time
        let elapsedTime = NSDate(timeIntervalSince1970: (self.pooData!["elapsedTime"]! as NSString).doubleValue)
        self.lblTime.setText(self.df.stringFromDate(elapsedTime))


        // todo: have an option to use 12 or 24hr time
        // will be easier once i get all my common code together.
        // the reason i do this after elapsedTime is because it would adjust
        // elapsedTimes hours (from the timezone change).
        // start and stop time depend on setting the timezone to local time
        self.df.timeZone = NSTimeZone.localTimeZone()
        self.df.dateFormat = "hh:mm:ss a"


        // stop time
        let stopTime = NSDate(timeIntervalSince1970: (self.pooData!["stopTime"]! as NSString).doubleValue)
        self.lblStop.setText(self.df.stringFromDate(stopTime))

        // start time
        let startTime = NSDate(timeIntervalSince1970: (self.pooData!["startTime"]! as NSString).doubleValue)
        self.lblStart.setText(self.df.stringFromDate(startTime))

        // change dateFormat to get day(man) stuff, for date label
        self.df.dateFormat = "MMM dd, YYYY"
        self.lblDate.setText(self.df.stringFromDate(startTime))

    }
}