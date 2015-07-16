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
    @IBOutlet weak var lblCash: WKInterfaceLabel!
    @IBOutlet weak var btnDelete: WKInterfaceButton!


    var pooData: [String:String]?


    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        self.pooData = context! as? [String : String]

        self.populateData()
    }


    func populateData()
    {
        for (time, money) in self.pooData!
        {
            self.lblTime.setText(time)
            self.lblCash.setText(money)
        }
    }
}