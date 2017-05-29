//
//  SettingsTableViewController.swift
//  BikeOrNot
//
//  Created by Joel Bell on 6/13/16.
//  Copyright © 2016 Joel Bell. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var tempRangeCell = UITableViewCell()
    var conditionHotCell = UITableViewCell()
    var conditionWarmCell = UITableViewCell()
    var conditionCoolCell = UITableViewCell()
    var conditionColdCell = UITableViewCell()
    
    override func loadView() {
        super.loadView()
        
        self.title = "Settings"
        
        self.tempRangeCell.textLabel?.text = "Range"
        self.conditionHotCell.textLabel?.text = "Hot"
        self.conditionWarmCell.textLabel?.text = "Warm"
        self.conditionCoolCell.textLabel?.text = "Cool"
        self.conditionColdCell.textLabel?.text = "Cold"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1
        case 1: return 4
        default: fatalError("Unknown number of sections")
        }
    }
    
    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch((indexPath as NSIndexPath).section) {
        case 0:
            switch((indexPath as NSIndexPath).row) {
            case 0: return self.tempRangeCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch((indexPath as NSIndexPath).row) {
            case 0: return self.conditionHotCell
            case 1: return self.conditionWarmCell
            case 2: return self.conditionCoolCell
            case 3: return self.conditionColdCell
            default: fatalError("Unknown row in section 1")
            }
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Temperature"
        case 1: return "Conditions"
        default: fatalError("Unknown section")
        }
    }
    
    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) == self.tempRangeCell {
            
            self.performSegue(withIdentifier: "ShowRangeSegue", sender: nil)
        }
        if tableView.cellForRow(at: indexPath) == self.conditionHotCell {
            
            self.performSegue(withIdentifier: "ShowConditionSegue", sender: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if  segue.identifier == "ShowRangeSegue" {
//            segue.destinationViewController as? ChooseTempViewController
//            
//        }
    }
    
}
