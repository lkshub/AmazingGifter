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


   // @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var giftImageView: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!

    @IBAction func datePickerValue(_ sender: AnyObject) {
         datePickerChanged()
    }
    @IBOutlet weak var ReasonButtonOutlet: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    //var reasonText = ""
    var datePickerHidden = true
    var searchItem = NSMutableDictionary()
    var picked = false
    var newGift: Gift?
    var user: User!
    let brain = dataBrain.sharedDataBrain
    
    
      
    @IBAction func comfirmAction(_ sender: AnyObject) {
        confirm()
    }
    
 
    override func viewDidAppear(_ Animated:Bool) {
        super.viewDidAppear(true)
        datePickerChanged()
        //reasonLabel.text = reasonText
        if(picked){
            let url = URL(string: searchItem["galleryURL"] as? NSString as! String)
            let data = try? Data(contentsOf: url!)
            self.giftImageView.contentMode = .scaleAspectFit
            self.giftImageView.image = UIImage(data: data!)
        }
        
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func datePickerChanged () {
     
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let dateString = dateFormatter.string(from: datePicker.date)
        detailLabel.text = dateString
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            toggleDatepicker()
        }
        tableView.cellForRow(at: indexPath)?.isSelected = false

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 1 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        
        
    }
    
    
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionHeaderHeight
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        return tableView.sectionFooterHeight
    }

    func confirm(){
        if(picked){
            let todaysDate:Date = Date()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            let DateInFormat:String = dateFormatter.string(from: todaysDate)
            var reason :String = ""

            reason = self.ReasonButtonOutlet.titleLabel!.text!

            newGift = Gift(itemID: searchItem["itemId"] as! String,itemURL: searchItem["viewItemURL"] as! String,dueDate: detailLabel.text!,initiatorID: brain.uid,name: searchItem["title"] as! String,pictureURL: searchItem["galleryURL"] as! String,postTime: DateInFormat, price: searchItem["convertedCurrentPrice"] as! String,reason: reason,receiverID: brain.visitedUser.uid,category:searchItem["category"] as! String)

            self.brain.addNewGift (newGift!)
            let n: Int! = self.navigationController?.viewControllers.count
            if let giftViewController = self.navigationController?.viewControllers[n-2] as? FirstViewController{
                //giftViewController.fetchGifts()
                self.navigationController?.popToViewController(giftViewController, animated: true)
            }
        }
    }
}

