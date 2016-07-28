//
//  ContributionDetailsUITableViewController.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/16/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit
import Firebase
class ContributionDetailsUITableViewController: UITableViewController {
    var gift: Gift?
    let brain = dataBrain.sharedDataBrain
    var contributions:[[String: AnyObject]] = []{
        didSet{
            tableView.reloadData()
        }
    }
    var contributor : [String] = []{
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = brain.ref.child("contribution").child(gift!.auto_id!)
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let emu = snapshot.children
            while let rest = emu.nextObject() as? FIRDataSnapshot {
                
                
                let contribution = ["amount": rest.value!["amount"] as! Double,
                    "contributor_id": rest.value!["contributor_id"] as! String,
                    "contributor_name": rest.value!["contributor_name"] as! String,
                    "time" : rest.value!["time"] as! String
                ]

                self.contributions.append(contribution as! [String : AnyObject])
            }
        })
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contributions.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "contributionTableCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContributionTableCell
        cell.amountLabel.text = "$ "+String(contributions[indexPath.row]["amount"]!)
        cell.contributorLabel.text = contributions[indexPath.row]["contributor_name"] as? String
        cell.timeLabel.text = contributions[indexPath.row]["time"] as? String
        return cell
    }
    
}