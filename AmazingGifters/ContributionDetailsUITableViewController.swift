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
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let emu = snapshot.children
            while let data = emu.nextObject() as? FIRDataSnapshot {
                let rest = data.value as? [String : Any]
                
                let contribution = [
                    "amount": rest!["amount"] as! Double,
                    "contributor_id": rest!["contributor_id"] as! String,
                    "contributor_name": rest!["contributor_name"] as! String,
                    "time" : rest!["time"] as! String
                ] as [String : Any]

                self.contributions.append(contribution as [String : AnyObject])
            }
        })
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contributions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "contributionTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ContributionTableCell
        cell.amountLabel.text = "$ "+String(describing: contributions[indexPath.row]["amount"]!)
        cell.contributorLabel.text = contributions[indexPath.row]["contributor_name"] as? String
        cell.timeLabel.text = contributions[indexPath.row]["time"] as? String
        return cell
    }
    
}
