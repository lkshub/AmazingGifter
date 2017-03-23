//
//  AddressTableViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class AddressTableViewController: UITableViewController {

    @IBAction func backBtnClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let labels = [nameLabel,addressFirstLabel,addressSecondLabel,cityLabel,stateLabel,zipLabel,countryLabel,phoneLabel]
        for (index,label) in labels.enumerated(){
            label?.text = brain.user.profile![keys[index]] as? String
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let editAddressTVC = self.storyboard!.instantiateViewController(withIdentifier: "EditAddressView") as? EditAddressTableViewController{
        editAddressTVC.text = brain.user.profile![keys[indexPath.row]] as? String
        editAddressTVC.key = keys[indexPath.row] 
        self.show(editAddressTVC, sender: nil)
        }
    }
    


    
}
