//
//  ProfileTableViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    @IBAction func backBtn(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    let brain = dataBrain.sharedDataBrain
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = brain.user.profile!["name"] as? String
        emailLabel.text = brain.user.profile!["email"] as? String
        birthdayLabel.text = brain.user.profile!["birthday"] as? String
    }
}
