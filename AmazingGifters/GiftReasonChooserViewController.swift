//
//  GiftReasonChooserViewController.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/16/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import UIKit

class GiftReasonChooserViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var otherTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        otherTextField.delegate = self
    
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        let n: Int! = self.navigationController?.viewControllers.count
        if let addGiftController = self.navigationController?.viewControllers[n-2] as? AddGiftTableViewContonller{
            var reason : String = "Other"
            if(otherTextField.text!.characters.count != 0){
                reason = otherTextField!.text!
            }
            addGiftController.ReasonButtonOutlet.setTitle(reason, forState: .Normal);
            self.navigationController?.popToViewController(addGiftController, animated: true)
        }

        return true
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row != 6){
            let n: Int! = self.navigationController?.viewControllers.count
            if let addGiftController = self.navigationController?.viewControllers[n-2] as? AddGiftTableViewContonller{
            addGiftController.ReasonButtonOutlet.setTitle(tableView.cellForRowAtIndexPath(indexPath)!.textLabel!.text!, forState: .Normal);
                self.navigationController?.popToViewController(addGiftController, animated: true)
            }
        }
        else{
            let n: Int! = self.navigationController?.viewControllers.count
            if let addGiftController = self.navigationController?.viewControllers[n-2] as? AddGiftTableViewContonller{
                var reason : String = "Other"
                if(otherTextField.text!.characters.count != 0){
                    reason = otherTextField!.text!
                }
                addGiftController.ReasonButtonOutlet.setTitle(reason, forState: .Normal);
                self.navigationController?.popToViewController(addGiftController, animated: true)
            }
        
        }
    }
}
