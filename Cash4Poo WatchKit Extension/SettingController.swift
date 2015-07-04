//
//  SettingController.swift
//  Cash4Poo
//
//  Created by brandon on 7/4/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import WatchKit

class SettingController: WKInterfaceController
{
    @IBOutlet weak var btnSave: WKInterfaceButton!
    @IBOutlet weak var sldrSalary: WKInterfaceSlider!
    @IBOutlet weak var lblValue: WKInterfaceLabel!

    @IBAction func changeValue(value: Float)
    {
        self.lblValue.setText("\(value)")
    }


    @IBAction func save()
    {
        self.dismissController()
    }



    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)

        // Configure interface objects here.
        println("fart")
        println(context)
    }
}