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

    var settings: NSUserDefaults?

    override func viewDidLoad() {
        super.viewDidLoad()

        // load up settings
        self.settings = NSUserDefaults.standardUserDefaults()
        
        // populate settings fields from saved settings
        if let annualSalary = self.settings?.integerForKey("annualSalary")
        {
            // txtAnnualSalary.setText(annualSalary)
            println("settings: annual salary: \(annualSalary)")
        }
        
        if let workHours = self.settings?.integerForKey("workHours")
        {
            // txtWorkHours.setText(workHours)
            println("settings: workhours: \(workHours)")
        }

        // for keyboard return button
        // on normal keyboard. the number board
        // i cant figure out how to get a done button
        self.txtAnnualSalary.keyboardType = .NumberPad
        self.txtAnnualSalary.delegate = self
    }
    
    
    
    @IBAction func saveSettings(sender: UIButton)
    {
        if let annualSalary = self.txtAnnualSalary.text.toInt()
        {
            self.settings!.setInteger(annualSalary, forKey: "annualSalary")
        }



        self.settings!.synchronize()

        // resign first responder for this textfield to dismiss keyboard.
        // do i just pick any textbox to do this on because this view implements uitextfielddelegate, and the responder just picks it up regardless?
        // todo: test this when i have more boxes
        self.txtAnnualSalary.resignFirstResponder()
        
        var alert = UIAlertController(
            title: "Cash4Poo",
            message: "Settings Saved",
            preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }






    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
