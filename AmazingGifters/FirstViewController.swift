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
    let sectionKey = ["wish_list","from_my_friend"]
    //var section0 :[String] = []
    //var section0Gift :[Gift] = []
    //var section1 :[String] = []
    let brain = dataBrain.sharedDataBrain
    var gifts:[Array<Gift>] = [[],[],[]] {
        didSet{
            tableView.reloadData()
        }
    }
    var user:User!
    
    func setTimeout(delay:NSTimeInterval, block:()->Void) -> NSTimer {
        return NSTimer.scheduledTimerWithTimeInterval(delay, target: NSBlockOperation(block: block), selector: #selector(NSOperation.main), userInfo: nil, repeats: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil{
            user = brain.user
        }
        fetchGifts()
        brain.visitedUser  = self.user
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchGifts(){
        for index in [0,1]{
            brain.ref.child("user").child(self.user.uid).child("my_gift").child(sectionKey[index]).observeEventType(.Value, withBlock: { (snapshot) in
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    self.gifts[index] = []
                    let element = rest.key
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
                        self.gifts[index].append(gift)
                        self.tableView.reloadData()
                    })
                }
            })
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GiftTableViewCell
        cell.giftNameLabel?.text = self.gifts[indexPath.section][indexPath.row].name
        cell.giftDueDateLabel?.text = self.gifts[indexPath.section][indexPath.row].dueDate
        cell.giftReasonCell?.text = "For " + self.gifts[indexPath.section][indexPath.row].reason!
        let url = NSURL(string: self.gifts[indexPath.section][indexPath.row].pictureURL! as NSString as String)
        let data = NSData(contentsOfURL: url!)
        cell.giftImageView.contentMode = .ScaleAspectFit
        cell.giftImageView.image = UIImage(data: data!)
        cell.giftProgressView.transform = CGAffineTransformMakeScale( 1, 3)
        cell.giftProgressView.setProgress(Float(self.gifts[indexPath.section][indexPath.row].progress!/self.gifts[indexPath.section][indexPath.row].price!), animated: false)
        
        let f = Float(self.gifts[indexPath.section][indexPath.row].progress!/self.gifts[indexPath.section][indexPath.row].price!) * 100
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
       
}

