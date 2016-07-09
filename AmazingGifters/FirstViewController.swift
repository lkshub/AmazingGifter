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
    
    let section = ["Wish List", "From Friends", "Received"]
    var section0 :[String] = []
    var section0Gift :[Gift] = []
    var section1 :[String] = []
    let brain = dataBrain.sharedDataBrain
    var gifts:[Gift] = []

    
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: #selector(NSOperation.main), userInfo: nil, repeats: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        brain.ref.child("user").child(brain.uid).child("my_gift").child("wish_list").observeEventType(.Value, withBlock: { (snapshot) in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                self.section0.append(rest.key)
                
            }
            
            for element in self.section0{
                
                self.brain.ref.child("gift").child(element).observeEventType(.Value, withBlock: { (snapshot) in
                    let gift : Gift = Gift(
                        itemID: (snapshot.value!["itemID"] as? String)!,
                        itemURL: (snapshot.value!["itemURL"] as? String)!,
                        dueDate: (snapshot.value!["dueDate"] as? String)!,
                        initiatorID: (snapshot.value!["initiatorID"] as? String)!,
                        name: (snapshot.value!["name"] as? String)!,
                        pictureURL: (snapshot.value!["pictureURL"] as? String)!,
                        postTime: (snapshot.value!["postTime"] as? String)!,
                        price: (snapshot.value!["price"] as? Double)!,
                        reason: (snapshot.value!["reason"] as? String)!,
                        receiverID: (snapshot.value!["receiverID"] as? String)!,
                        progress: (snapshot.value!["progress"] as? Double)!
                    )
                    self.section0Gift.append(gift)
                    self.tableView.reloadData()
                })
            }
        })

        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.section[section]
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "myGiftFromWishList"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GiftTableViewCell
        if(indexPath.section == 0 ){
            cell.giftNameLabel?.text = self.section0Gift[indexPath.row].name
            cell.giftDueDateLabel?.text = self.section0Gift[indexPath.row].dueDate
            cell.giftReasonCell?.text = "For " + self.section0Gift[indexPath.row].reason!
            let url = NSURL(string: self.section0Gift[indexPath.row].pictureURL! as NSString as String)
            let data = NSData(contentsOfURL: url!)
            cell.giftImageView.contentMode = .ScaleAspectFit
            cell.giftImageView.image = UIImage(data: data!)
            cell.giftProgressView.transform = CGAffineTransformMakeScale( 1, 3)
            cell.giftProgressView.setProgress(Float(self.section0Gift[indexPath.row].progress!/self.section0Gift[indexPath.row].price!), animated: false)
            
            let f = Float(self.section0Gift[indexPath.row].progress!/self.section0Gift[indexPath.row].price!) * 100
            let progress = String(format: "%.01f", f)
            cell.progressViewNumber.text = progress + "%"
        }
        else if(indexPath.section == 1 ){
            cell.textLabel?.text = self.section1[indexPath.row] as! String
        }

        // Fetches the appropriate meal for the data source layout.
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.section.count
        
    }
 
   

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0){
            return self.section0Gift.count
        }
        else if(section == 1){
            return self.section1.count
        }else{
            return 0
        }
    }
       

}

