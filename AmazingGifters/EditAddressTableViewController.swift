//
//  EditAddressTableViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class EditAddressTableViewController: UITableViewController {
    let brain = dataBrain.sharedDataBrain
    var text:String?
    @IBOutlet weak var addressText: UITextField!
    
    var key:String!
    
    @IBAction func saveBtnClicked(_ sender: UIBarButtonItem) {
        brain.user.profile!.setValue(addressText.text, forKeyPath: key)
        let n: Int! = self.navigationController?.viewControllers.count
        if let addressBookView = self.navigationController?.viewControllers[n-2] as? AddressTableViewController{
            //giftViewController.fetchGifts()
            self.navigationController?.popToViewController(addressBookView, animated: true)
        }
        brain.ref.child("user").child(brain.user.uid).child(key).setValue(addressText.text ?? "")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addressText.text = text
    }
    

    
}
