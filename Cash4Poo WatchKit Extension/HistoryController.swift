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


    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        println("segueing")
        println(rowIndex)

        if (segueIdentifier == "historyDetailSegue")
        {
            println("seguing to historyDetailSegue with self.pooHistory")

            // the dumbest way to do something, ever
            for (index, poo) in enumerate(self.pooHistory!)
            {
                if index == rowIndex
                {
                    return poo
                }
            }
        }

        return nil
    }


    // todo: replace this with data from main controller
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

        for (index, poo) in enumerate(self.pooHistory!)
        {
            let row = self.tblHistory.rowControllerAtIndex(index) as! PooHistoryTableRowController

            for (time, money) in poo
            {
                row.lblTime.setText(time)
                row.lblGrossProfit.setText(money)
            }
        }
    }
}