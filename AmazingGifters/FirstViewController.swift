//
//  FirstViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit
import Firebase
class FirstViewController: UITableViewController {
    
    let sectionName = ["Wish List", "From Friends", "Received"]
    let sectionKey = ["wish_list","from_friends"]
    let brain = dataBrain.sharedDataBrain
    var gifts:[Array<Gift>] = [[],[],[]] {
        didSet{
            tableView.reloadData()
        }
    }
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil{
            user = brain.user
        }
        fetchGifts()
        //brain.visitedUser = self.user
        //addProgressLisenter()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func fetchGiftsOnce(){
        self.gifts = [[],[],[]]
        for index in [0,1]{
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                //self.gifts[index] = []
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    let element = rest.key
                    self.brain.ref.child("gift").child(element).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        if !(snapshot.value is NSNull) {
                            let gift = self.getGiftFromSnapshot(element,snapshot:snapshot,hidden: index == 1 && self.user.uid == self.brain.user.uid)
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yy"
                            let date = dateFormatter.dateFromString(gift.dueDate!)?.addDays(1)
                            let currentDateTime = NSDate()
                            
                            if(gift.price<=gift.progress && !currentDateTime.isLessThanDate(date!)){
                                gift.hidden = false
                                self.gifts[2].insert(gift,atIndex:0)
                                
                            }else{
                                self.gifts[index].insert(gift,atIndex: 0)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func fetchGifts(){
        self.gifts = [[],[],[]]
        for index in [0,1]{
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observeEventType(.ChildAdded, withBlock: { (snapshot) in
                
                let element = snapshot.key
                self.brain.ref.child("gift").child(element).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if !(snapshot.value is NSNull) {
                        let gift = self.getGiftFromSnapshot(element,snapshot: snapshot,hidden: index == 1 && self.user.uid == self.brain.user.uid)
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yy"
                        let date = dateFormatter.dateFromString(gift.dueDate!)?.addDays(1)
                        let currentDateTime = NSDate()
                        
                        if(gift.price<=gift.progress && !currentDateTime.isLessThanDate(date!)){
                            gift.hidden = false
                            self.gifts[2].insert(gift,atIndex:0)
                            
                        }else{
                            self.gifts[index].insert(gift,atIndex: 0)
                        }
                    }
                })
                self.brain.ref.child("gift").child(element).observeEventType(.ChildChanged, withBlock: { (snapshot) in
                    self.fetchGiftsOnce()
                })
                
                
            })
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observeEventType(.ChildRemoved, withBlock: { (snapshot) in
                self.fetchGiftsOnce()
            })
        }

    }

    func getGiftFromSnapshot(auto_id:String,snapshot:FIRDataSnapshot,hidden:Bool) -> Gift{
        print(snapshot)
        let gift : Gift = Gift(
            itemID: (snapshot.value!["item_id"] as? String)!,
            itemURL: (snapshot.value!["item_url"] as? String)!,
            dueDate: (snapshot.value!["due_date"] as? String)!,
            initiatorID: (snapshot.value!["initiator_id"] as? String)!,
            name: (snapshot.value!["name"] as? String)!,
            pictureURL: (snapshot.value!["picture_url"] as? String)!,
            postTime: (snapshot.value!["post_time"] as? String)!,
            price: (snapshot.value!["price"] as? Double)!,
            reason: (snapshot.value!["reason"] as? String)!,
            receiverID: (snapshot.value!["receiver_id"] as? String)!,
            progress: (snapshot.value!["progress"] as? Double)!,
            category: (snapshot.value!["category"] as? String)!,
            hidden: hidden
        )
        gift.auto_id  = auto_id
        return gift
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionName[section]
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GiftTableViewCell"
        let gift = gifts[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GiftTableViewCell
        cell.giftNameLabel?.text = (gift.hidden==true ? ("some "+gift.category!):(gift.name!))
        cell.giftDueDateLabel?.text = gift.dueDate
        cell.giftReasonCell?.text = "For " + gift.reason!
        let url = NSURL(string: (gift.hidden==true ? ("https://ouryoungaddicts.files.wordpress.com/2015/06/clue.jpeg"):(gift.pictureURL! as NSString as String)) )
        let data = NSData(contentsOfURL: url!)
        cell.giftImageView.contentMode = .ScaleAspectFit
        cell.giftImageView.image = UIImage(data: data!)
        cell.giftProgressView.transform = CGAffineTransformMakeScale( 1, 3)
        cell.giftProgressView.setProgress(Float(gift.progress!/gift.price!), animated: false)
        
        let f = Float(gift.progress!/gift.price!) * 100
        let progress = String(format: "%.01f", f)
        cell.progressViewNumber.text = progress + "%"


        // Fetches the appropriate meal for the data source layout.
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return gifts.count
    }
 
   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gifts[section].count
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGiftDetailTableSegue"
        {
            if let destinationVC = segue.destinationViewController as? GiftDetailTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                    destinationVC.gift = gifts[indexPath.section][indexPath.row]
                    cell.selected = false
                }
                brain.visitedUser = self.user
            }
        }
        if segue.identifier == "toAddGift"
        {
            if segue.destinationViewController is AddGiftTableViewContonller{
                brain.visitedUser = self.user
            }
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "showGiftDetailTableSegue" {
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
                if gifts[indexPath.section][indexPath.row].hidden == true {
                    let alertController = UIAlertController(title: "Surprise!", message:
                        "Gift details unavailable until the due date!", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    cell.selected = false
                    return false
                }
            }
        }
        // by default, transition
        return true
    }

}



extension NSDate {
    
    
    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    
    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.dateByAddingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
}
