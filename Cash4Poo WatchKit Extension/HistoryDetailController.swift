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
    let c4p = C4PCommon.sharedInstance


    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)

        var index = context as! Int

        if let pooHistory = self.c4p.pooHistory
        {
            for (i, poo) in enumerate(pooHistory)
            {
                if index == i
                {
                    self.pooData = poo
                    break;
                }
            }

            self.populateData()
        }
    }


    func populateData()
    {
        if let pooData = self.pooData
        {
            // default formatters
            self.c4p.defaultFormatters()

            if let grossProfit = pooData["grossProfit"]
            {
                self.lblProfit.setText(self.c4p.getGrossProfitString(grossProfit))
            }

            if let elapsedTime = pooData["elapsedTime"]
            {
                self.lblTime.setText(self.c4p.getTimeString(elapsedTime))
            }

            // todo: have an option to use 12 or 24hr time
            // the reason i do this after elapsedTime is because it would adjust
            // elapsedTimes hours (from the timezone change).
            // start and stop time depend on setting the timezone to local time
            self.c4p.dateFormatter.timeZone = NSTimeZone.localTimeZone()
            self.c4p.dateFormatter.dateFormat = "hh:mm:ss a"

            if let stopTime = pooData["stopTime"]
            {
                self.lblStop.setText(self.c4p.getTimeString(stopTime))
            }

            if let startTime = pooData["startTime"]
            {
                self.lblStart.setText(self.c4p.getTimeString(startTime))

                // change dateFormat to get day(man) info for date label
                // just re-use startTime cause i'm getting different data from it
                self.c4p.dateFormatter.dateFormat = "MMM dd, YYYY"
                self.lblDate.setText(self.c4p.getTimeString(startTime))
            }
        }
    }
}