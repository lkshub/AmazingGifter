//
//  AddressTableViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class AddressTableViewController: UITableViewController {

    @IBAction func backBtnClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressFirstLabel: UILabel!
    @IBOutlet weak var addressSecondLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    let keys  = ["name","address_first","address_second","city","state","zipcode","country","phone"]
    
    let brain = dataBrain.sharedDataBrain
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let labels = [nameLabel,addressFirstLabel,addressSecondLabel,cityLabel,stateLabel,zipLabel,countryLabel,phoneLabel]
        for (index,label) in labels.enumerate(){
            label.text = brain.user.profile![keys[index]] as? String
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let editAddressTVC = self.storyboard!.instantiateViewControllerWithIdentifier("EditAddressView") as? EditAddressTableViewController{
        editAddressTVC.text = brain.user.profile![keys[indexPath.row]] as? String
        editAddressTVC.key = keys[indexPath.row] 
        self.showViewController(editAddressTVC, sender: nil)
        }
    }
    


    
}
