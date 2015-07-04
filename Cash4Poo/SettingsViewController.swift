//
//  SettingsViewController.swift
//  Cash4Poo
//
//  Created by brandon on 7/3/15.
//  Copyright (c) 2015 cbcoding. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtAnnualSalary: UITextField!
    @IBOutlet weak var txtWorkHours: UITextField!

    var settings: NSUserDefaults?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // for keyboard return button
        // on normal keyboard. the number board
        // i cant figure out how to get a done button
        self.txtAnnualSalary.keyboardType = .NumberPad
        self.txtAnnualSalary.delegate = self
        self.txtWorkHours.keyboardType = .NumberPad
        self.txtWorkHours.delegate = self
        
        self.loadSettings()
    }


    func loadSettings()
    {
        self.settings = NSUserDefaults.standardUserDefaults()
        self.populateSettings()
    }

    func populateSettings()
    {
        // populate settings fields from saved settings
        if let annualSalary = self.settings?.integerForKey("annualSalary")
        {
            self.txtAnnualSalary.text = String(annualSalary)
        }
        
        if let workHours = self.settings?.integerForKey("workHours")
        {
            self.txtWorkHours.text = String(workHours)
        }
    }

    func saveSettings()
    {
        if let annualSalary = self.txtAnnualSalary.text.toInt()
        {
            self.settings!.setInteger(annualSalary, forKey: "annualSalary")
        }
        
        if let workHours = self.txtWorkHours.text.toInt()
        {
            self.settings!.setInteger(workHours, forKey: "workHours")
        }

        self.settings!.synchronize()

        var alert = UIAlertController(
            title: "Cash4Poo",
            message: "Settings Saved",
            preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    
        // resign keyboard responders
        self.txtAnnualSalary.resignFirstResponder()
        self.txtWorkHours.resignFirstResponder()
    }










    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func btnSave(sender: AnyObject) {
        self.saveSettings()
    }
}
