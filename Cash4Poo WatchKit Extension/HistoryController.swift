//
//  HistoryController.swift
//  Cash4Poo
//
//  Created by brandon on 7/14/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit

class HistoryController: WKInterfaceController
{
    @IBOutlet weak var grpNoHistory: WKInterfaceGroup!
    @IBOutlet weak var tblHistory: WKInterfaceTable!

    var pooHistory: [[String:String]]?
    var userData: NSUserDefaults?


    override func willActivate()
    {
        self.userData = NSUserDefaults(suiteName: "group.cash4poo")

        if let history = self.userData?.arrayForKey("history") as? [[String:String]]
        {
            self.pooHistory = history
            self.grpNoHistory.setHidden(true)

            self.populatePooHistory()
        }
        else
        {
            self.grpNoHistory.setHidden(false)
        }
    }


    func populatePooHistory()
    {
        self.tblHistory.setNumberOfRows(self.pooHistory!.count, withRowType: "PooHistoryTableRowController")

        var index: Int = 0
        for poo in self.pooHistory!
        {
            let row = self.tblHistory.rowControllerAtIndex(index) as! PooHistoryTableRowController

            for (time, money) in poo
            {
                row.lblTime.setText(time)
                row.lblGrossProfit.setText(money)
            }

            index++;
        }
    }
}