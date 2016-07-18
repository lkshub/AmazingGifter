//
//  AddressTableViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class AddressTableViewController: UITableViewController {

    @IBAction func backBtn(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    let labels = ["Full Name","Address Line 1","Address Line 2","City","State","ZIP Code","Country","Phone Number"]
    let keys  = ["name","address_first","address_second","city","state","zipcode","country","phone"]
    
    let brain = dataBrain.sharedDataBrain
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //cell.style
        cell.textLabel!.text = labels[indexPath.row] 
        cell.detailTextLabel!.text = brain.user.profile![keys[indexPath.row]] as? String
        return cell
        
    }
}
