//
//  ViewController.swift
//  tips
//
//  Created by Kenneth Pu on 9/14/15.
//  Copyright (c) 2015 Kenneth Pu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var numPeopleLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var finalLabel: UILabel!
    
    var percentStart = 0.0
    var tipPercentage = 0.15
    var peopleStart = 0
    var numPeople:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize labels
        tipLabel.text = "Tip Amount"
        totalLabel.text = "Subtotal"
        finalLabel.text = "Final"
        numPeopleLabel.text = "1/p"
        percentLabel.text = "+15%"
        
        // Bring up keyboard
        billField.becomeFirstResponder()
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        if (billField.text.isEmpty) {
            // If billField is empty set placeholder text for labels
            tipLabel.text = "Tip Amount"
            totalLabel.text = "Subtotal"
            finalLabel.text = "Final"
        } else {
            // Calculate new tip, subtotal, and final values based on specified bill amount
            var billAmount = NSString(string: billField.text).doubleValue
            var tip = billAmount * tipPercentage
            var total = billAmount + tip
            var final = total / Double(numPeople)
            
            // Update label values
            tipLabel.text = String(format: "$%.2f", tip)
            totalLabel.text = String(format: "$%.2f", total)
            finalLabel.text = String(format: "$%.2f", final)
        }
    }
    
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(self.view)
        if (sender.state == UIGestureRecognizerState.Began) {
            // Save initial values
            peopleStart = numPeople
            percentStart = tipPercentage
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            // Panning up/down increases/decreases the number of people to split bill between (range is 1 to 9)
            numPeople = max(min(peopleStart + Int(-translation.y / 20),9),1)
            numPeopleLabel.text = "\(numPeople)/p"
            
            // Panning right/left increases/decreases the tip percentage (range is 10% to 30%)
            tipPercentage = round(max(min(percentStart + Double(translation.x / 2000.0),0.30),0.10) * 100)/100
            percentLabel.text = "+\(Int(tipPercentage*100))%"
        }
        // Calculate new values and update UI accordingly
        self.onEditingChanged(sender)
    }
}

