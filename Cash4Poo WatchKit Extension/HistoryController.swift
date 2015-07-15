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

        for (index, pooItem) in enumerate(self.pooHistory!)
        {
            let row = self.tblHistory.rowControllerAtIndex(index) as! PooHistoryTableRowController

            row.lblGrossProfit.setText("$69.69")
            row.lblTime.setText("8:00:85")
        }
    }
}