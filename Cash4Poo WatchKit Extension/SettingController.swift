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

    var dictatedValue:Int?
    var settingType:String?

    @IBAction func save()
    {
        // todo: communicate with ios app to save something

        if (self.dictatedValue != nil)
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


    func getDictatedValue()
    {
        presentTextInputControllerWithSuggestions(nil,
            allowedInputMode: .Plain,
            completion: {(input) -> Void in
                var labelText: String = "Please try again."
                if (input != nil)
                {
                    // inputStr used for display
                    let inputStr = input[0] as? String
                    
                    // inputStrNC no commas for Int cast
                    let inputStrNC = inputStr!.stringByReplacingOccurrencesOfString(",", withString: "")
                    
                    // inputInt used for saving the setting
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

                        self.dictatedValue = inputInt!
                    }
                }

                self.lblValue.setText(labelText)
            }
        )
    }



    override func awakeWithContext(context: AnyObject?)
    {
        super.awakeWithContext(context)

        self.settingType = context as? String

        // immediately try to get a dictated value
        self.getDictatedValue()
    }
}