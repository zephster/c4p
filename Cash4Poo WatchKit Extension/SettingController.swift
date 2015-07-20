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
    @IBOutlet weak var btnDictate: WKInterfaceButton!
    @IBOutlet weak var lblValue: WKInterfaceLabel!

    // buttans!!1!
    @IBOutlet weak var btnClr: WKInterfaceButton!
    @IBOutlet weak var btn0: WKInterfaceButton!
    @IBOutlet weak var btn1: WKInterfaceButton!
    @IBOutlet weak var btn2: WKInterfaceButton!
    @IBOutlet weak var btn3: WKInterfaceButton!
    @IBOutlet weak var btn4: WKInterfaceButton!
    @IBOutlet weak var btn5: WKInterfaceButton!
    @IBOutlet weak var btn6: WKInterfaceButton!
    @IBOutlet weak var btn7: WKInterfaceButton!
    @IBOutlet weak var btn8: WKInterfaceButton!
    @IBOutlet weak var btn9: WKInterfaceButton!


    var inputValue:Int = 0
    var settingType:String?

    let c4p = C4PCommon.sharedInstance


    // load up user data, set label
    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)
        self.settingType = context as? String
        var userData: Int?

        if (self.settingType == "annualSalary")
        {
            userData = self.c4p.annualSalary
        }
        else if (self.settingType == "workHours")
        {
            userData = self.c4p.workHours
        }

        // load setting and populate label
        if let data = userData
        {
            self.setValue(data, updateLabelWithValue: true)
        }
        else
        {
            self.setValue(0, updateLabelWithValue: true)
        }

        // immediately try to get a dictated value
        // todo: make this a setting in the watch app
        // self.getDictatedValue()
    }


    // append number and update the label
    func appendValue(appendVal: Int)
    {
        let appendedValStr:String = "\(self.inputValue)\(appendVal)"

        // too many = crash. like 15 or so, i didn't count
        if (count(appendedValStr) <= 10)
        {
            let appendedValInt:Int? = appendedValStr.toInt()
            self.setValue(appendedValInt, updateLabelWithValue: true)
        }
    }

    // directly set value, option to update label
    func setValue(value: Int?, updateLabelWithValue: Bool? = nil)
    {
        self.inputValue = value!

        if (updateLabelWithValue == true)
        {
            self.updateLabel()
        }
    }

    // update label with provided string, or if nil, the user inputted value
    func updateLabel(label: String? = nil)
    {
        if (label == nil)
        {
            let labelText: String?

            switch self.settingType!
            {
                case "annualSalary":
                    // bug: re-setting numberFormatter settings doesn't work
                    // so after this is run, it will forever be 0
                    // self.c4p.numberFormatter.maximumFractionDigits = 0
                    labelText = self.c4p.numberFormatter.stringFromNumber(self.inputValue)
                    // self.c4p.defaultFormatters()
                case "workHours":
                    fallthrough // basically, use default
                default:
                    labelText = String(self.inputValue)
            }

            self.updateLabel(label: "\(labelText!)")
        }
        else
        {
            self.lblValue.setText(label)
        }
    }

    // get dictated numerical value
    func getDictatedValue()
    {
        presentTextInputControllerWithSuggestions(nil,
            allowedInputMode: .Plain,
            completion: {(dictatedInput) -> Void in
                if (dictatedInput != nil)
                {
                    let inputStr = dictatedInput[0] as? String

                    // no commas for Int
                    let inputStrNC = inputStr!.stringByReplacingOccurrencesOfString(",", withString: "")

                    // used for saving the setting
                    let inputInt:Int? = inputStrNC.toInt()

                    if (inputInt != nil)
                    {
                        self.setValue(inputInt, updateLabelWithValue: true)
                    }
                    else
                    {
                        self.updateLabel(label: "Please try again.")
                    }
                }
                else
                {
                    self.updateLabel(label: "Please try again.")
                }
            }
        )
    }


    // UI actions
    @IBAction func saveButtonTap()
    {
        if (self.settingType == "annualSalary")
        {
            self.c4p.annualSalary = self.inputValue
        }
        else if (self.settingType == "workHours")
        {
            self.c4p.workHours = self.inputValue
        }

        self.c4p.saveData()
        self.dismissController()
    }

    @IBAction func dictateButtonTap()
    {
        self.getDictatedValue()
    }

    @IBAction func btnClrTap() { self.setValue(0, updateLabelWithValue: true) }
    @IBAction func btn0Tap() { self.appendValue(0) }
    @IBAction func btn1Tap() { self.appendValue(1) }
    @IBAction func btn2Tap() { self.appendValue(2) }
    @IBAction func btn3Tap() { self.appendValue(3) }
    @IBAction func btn4Tap() { self.appendValue(4) }
    @IBAction func btn5Tap() { self.appendValue(5) }
    @IBAction func btn6Tap() { self.appendValue(6) }
    @IBAction func btn7Tap() { self.appendValue(7) }
    @IBAction func btn8Tap() { self.appendValue(8) }
    @IBAction func btn9Tap() { self.appendValue(9) }
}