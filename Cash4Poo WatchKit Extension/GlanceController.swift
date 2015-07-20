//
//  GlanceController.swift
//  Cash4Poo WatchKit Extension
//
//  Created by brandon on 7/1/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController
{
    @IBOutlet weak var lblTotalProfit: WKInterfaceLabel!

    let c4p = C4PCommon.sharedInstance

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // load data and update labels here
        if let pooHistory = self.c4p.pooHistory
        {
            var totalProfit: Double = 0.00

            for (index, poo) in enumerate(pooHistory)
            {
                if let grossProfit = poo["grossProfit"]
                {
                    totalProfit += self.c4p.stringToDouble(grossProfit)
                }
            }

            self.lblTotalProfit.setText(self.c4p.getGrossProfitString("\(totalProfit)"))
        }
    }


    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Configure interface objects here.
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
