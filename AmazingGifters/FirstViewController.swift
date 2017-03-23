//
//  FirstViewController.swift
//  AmazingGifters
//
//  Created by 陆恺 on 6/18/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import UIKit
import Firebase
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}

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
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observeSingleEvent(of: .value, with: { (snapshot) in
                //self.gifts[index] = []
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    let element = rest.key
                    self.brain.ref.child("gift").child(element).observeSingleEvent(of: .value, with: { (snapshot) in
                        if !(snapshot.value is NSNull) {
                            let gift = self.getGiftFromSnapshot(element,snapshot:snapshot,hidden: index == 1 && self.user.uid == self.brain.user.uid)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MM/dd/yy"
                            let date = dateFormatter.date(from: gift.dueDate!)?.addDays(1)
                            let currentDateTime = Date()
                            
                            if(gift.price<=gift.progress && !currentDateTime.isLessThanDate(date!)){
                                gift.hidden = false
                                self.gifts[2].insert(gift,at:0)
                                
                            }else{
                                self.gifts[index].insert(gift,at: 0)
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
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observe(.childAdded, with: { (snapshot) in
                
                let element = snapshot.key
                self.brain.ref.child("gift").child(element).observeSingleEvent(of: .value, with: { (snapshot) in
                    if !(snapshot.value is NSNull) {
                        let gift = self.getGiftFromSnapshot(element,snapshot: snapshot,hidden: index == 1 && self.user.uid == self.brain.user.uid)
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yy"
                        let date = dateFormatter.date(from: gift.dueDate!)?.addDays(1)
                        let currentDateTime = Date()
                        
                        if(gift.price<=gift.progress && !currentDateTime.isLessThanDate(date!)){
                            gift.hidden = false
                            self.gifts[2].insert(gift,at:0)
                            
                        }else{
                            self.gifts[index].insert(gift,at: 0)
                        }
                    }
                })
                self.brain.ref.child("gift").child(element).observe(.childChanged, with: { (snapshot) in
                    self.fetchGiftsOnce()
                })
                
                
            })
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observe(.childRemoved, with: { (snapshot) in
                self.fetchGiftsOnce()
            })
        }

    }

    func getGiftFromSnapshot(_ auto_id:String,snapshot:FIRDataSnapshot,hidden:Bool) -> Gift{
        let value = snapshot.value as? [String : Any]
        let gift : Gift = Gift(
            itemID: (value!["item_id"] as? String)!,
            itemURL: (value!["item_url"] as? String)!,
            dueDate: (value!["due_date"] as? String)!,
            initiatorID: (value!["initiator_id"] as? String)!,
            name: (value!["name"] as? String)!,
            pictureURL: (value!["picture_url"] as? String)!,
            postTime: (value!["post_time"] as? String)!,
            price: (value!["price"] as? Double)!,
            reason: (value!["reason"] as? String)!,
            receiverID: (value!["receiver_id"] as? String)!,
            progress: (value!["progress"] as? Double)!,
            category: (value!["category"] as? String)!,
            hidden: hidden
        )
        gift.auto_id  = auto_id
        return gift
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionName[section]
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "GiftTableViewCell"
        let gift = gifts[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GiftTableViewCell
        cell.giftNameLabel?.text = (gift.hidden==true ? ("Some "+gift.category!):(gift.name!))
        cell.giftDueDateLabel?.text = gift.dueDate
        cell.giftReasonCell?.text = "For " + gift.reason!
        let url = URL(string: (gift.hidden==true ? ("https://ouryoungaddicts.files.wordpress.com/2015/06/clue.jpeg"):(gift.pictureURL! as NSString as String)) )
        let data = try? Data(contentsOf: url!)
        cell.giftImageView.contentMode = .scaleAspectFit
        cell.giftImageView.image = UIImage(data: data!)
        cell.giftProgressView.transform = CGAffineTransform( scaleX: 1, y: 3)
        cell.giftProgressView.setProgress(Float(gift.progress!/gift.price!), animated: false)
        
        let f = Float(gift.progress!/gift.price!) * 100
        let progress = String(format: "%.01f", f)
        cell.progressViewNumber.text = progress + "%"


        // Fetches the appropriate meal for the data source layout.
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return gifts.count
    }
 
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gifts[section].count
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGiftDetailTableSegue"
        {
            if let destinationVC = segue.destination as? GiftDetailTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destinationVC.gift = gifts[indexPath.section][indexPath.row]
                    cell.isSelected = false
                }
                brain.visitedUser = self.user
            }
        }
        if segue.identifier == "toAddGift"
        {
            if segue.destination is AddGiftTableViewContonller{
                brain.visitedUser = self.user
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showGiftDetailTableSegue" {
            
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                if gifts[indexPath.section][indexPath.row].hidden == true {
                    let alertController = UIAlertController(title: "Surprise!", message:
                        "Gift details unavailable until the due date!", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    cell.isSelected = false
                    return false
                }
            }
        }
        // by default, transition
        return true
    }

}



extension Date {
    
    
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    
    
    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)
        
        //Return Result
        return dateWithDaysAdded
    }
    
}
