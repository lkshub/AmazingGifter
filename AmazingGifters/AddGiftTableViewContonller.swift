//
//  AddGiftTableViewContonller.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/6/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit

class AddGiftTableViewContonller: UITableViewController {
    
    
    @IBOutlet weak var reasonLabel: UILabel!


    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var giftImageView: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!

    @IBAction func datePickerValue(sender: AnyObject) {
         datePickerChanged()
    }
    @IBOutlet weak var datePicker: UIDatePicker!
    //var reasonText = ""
    var datePickerHidden = true
    var searchItem = NSMutableDictionary()
    var picked = false
    var newGift: Gift?
    var user: User!
    let brain = dataBrain.sharedDataBrain
    
    
      
    @IBAction func comfirmAction(sender: AnyObject) {
        confirm()
    }
    
 
    override func viewDidAppear(Animated:Bool) {
        super.viewDidAppear(true)
        datePickerChanged()
        //reasonLabel.text = reasonText
        if(picked){
            let url = NSURL(string: searchItem["galleryURL"] as? NSString as! String)
            let data = NSData(contentsOfURL: url!)
            self.giftImageView.contentMode = .ScaleAspectFit
            self.giftImageView.image = UIImage(data: data!)
        }
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func datePickerChanged () {
     
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.stringFromDate(datePicker.date)
        detailLabel.text = dateString
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleDatepicker()
        }

    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
        
        
    }
    
    
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionHeaderHeight
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return tableView.sectionFooterHeight
    }
    /*
    var itemID : String?
    var itemURL : String?
    var dueDate: String
    var initiatorID: String?
    var name: String?
    var pictureURL: String?
    var postTime: String?
    var price: String?
    var reason: String?
    var receiverID: String?
     */
    func confirm(){
        if(picked){
            let todaysDate:NSDate = NSDate()
            let dateFormatter:NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
            var reason :String = ""
            if(reasonTextField.text?.characters.count>0){
                reason = reasonTextField.text!
            }
            newGift = Gift(itemID: searchItem["itemId"] as! String,itemURL: searchItem["viewItemURL"] as! String,dueDate: detailLabel.text!,initiatorID: brain.uid,name: searchItem["title"] as! String,pictureURL: searchItem["galleryURL"] as! String,postTime: DateInFormat, price: searchItem["convertedCurrentPrice"] as! String,reason: reason,receiverID: brain.visitedUser.uid)
            print("testgift")
            print(newGift?.itemID)
            print(newGift?.dueDate)
            print(newGift?.postTime)
            print(newGift?.reason)
            self.brain.addNewGift (newGift!)
            let n: Int! = self.navigationController?.viewControllers.count
            if let giftViewController = self.navigationController?.viewControllers[n-2] as? FirstViewController{
                self.navigationController?.popToViewController(giftViewController, animated: true)
            }
        }
    }
}

