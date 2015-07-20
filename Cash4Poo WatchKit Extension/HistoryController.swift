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

    let c4p = C4PCommon.sharedInstance


    // seguing to details view from tapped history row
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject?
    {
        if (segueIdentifier == "historyDetailSegue")
        {
            return rowIndex
        }

        return nil
    }


    override func willActivate()
    {
        if let history = self.c4p.pooHistory
        {
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
        if let pooHistory = self.c4p.pooHistory
        {
            self.c4p.defaultFormatters()

            self.tblHistory.setNumberOfRows(pooHistory.count, withRowType: "PooHistoryTableRowController")

            for (index, poo) in enumerate(pooHistory)
            {
                let row = self.tblHistory.rowControllerAtIndex(index) as! PooHistoryTableRowController

                if let grossProfit = poo["grossProfit"]
                {
                    let grossProfitString = self.c4p.getGrossProfitString(grossProfit)
                    row.lblGrossProfit.setText(grossProfitString)
                }

                if let elapsedTime = poo["elapsedTime"]
                {
                    let elapsedTimeString = self.c4p.getTimeString(elapsedTime)
                    row.lblTime.setText(elapsedTimeString)
                }
            }
        }
    }
}