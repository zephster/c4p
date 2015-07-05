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
    @IBOutlet weak var btnDot: WKInterfaceButton!
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

    var value:Int? = 0
    var settingType:String?

    @IBAction func save()
    {
        // todo: communicate with ios app to save something

        if (self.value != nil)
        {
            self.dismissController()
        }
        else
        {
            self.lblValue.setText("No value entered.")
        }
    }

    @IBAction func dictate()
    {
        self.getDictatedValue()
    }



    @IBAction func btnClrTap() { self.setValue(0, updateLabel: true) }
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
    // dot


    // this will be called by the buttons
    func appendValue(appendVal: Int)
    {
        let appendedValStr:String = "\(self.value!)\(appendVal)"

        // todo: check length, limit to like 9?

        let appendedValInt:Int? = appendedValStr.toInt()
        self.setValue(appendedValInt, updateLabel: true)
    }



    // set value, and update label
    func setValue(value: Int?, updateLabel: Bool? = nil)
    {
        self.value = value

        if (updateLabel == true)
        {
            self.updateLabel()
        }
    }

    private func updateLabel(label: String? = nil)
    {
        if (label == nil)
        {
            self.lblValue.setText("\(self.value!)")
        }
        else
        {
            self.lblValue.setText(label)
        }
    }

    func getDictatedValue()
    {
        presentTextInputControllerWithSuggestions(nil,
            allowedInputMode: .Plain,
            completion: {(input) -> Void in
                var labelText: String = "Please try again."
                if (input != nil)
                {
                    let inputStr = input[0] as? String

                    // no commas for Int
                    let inputStrNC = inputStr!.stringByReplacingOccurrencesOfString(",", withString: "")

                    // used for saving the setting
                    let inputInt:Int? = inputStrNC.toInt()

                    if (inputInt != nil)
                    {
                        switch self.settingType!
                        {
                            case "annualSalary":
                                labelText = "$\(inputStr!)"
                            case "workHours":
                                labelText = inputStr!
                            default:
                                labelText = "Invalid context."
                        }

                        self.setValue(inputInt)
                    }
                }

                self.updateLabel(label: labelText)
            }
        )
    }



    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)

        self.settingType = context as? String

        // immediately try to get a dictated value
//        self.getDictatedValue()
    }
}