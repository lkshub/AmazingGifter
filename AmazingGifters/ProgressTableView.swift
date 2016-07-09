//
//  ProgressTableView.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/9/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProgressTableView: UIViewController {
    

    let brain = dataBrain.sharedDataBrain
    
    @IBOutlet weak var tableView: UITableView!
    
    var gifts:[Gift]=[]{
        didSet{
            tableView.reloadData()
        }
    }
    var user:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = brain.user
        fetchGifts()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchGifts(){
            brain.ref.child("user").child(self.user.uid).child("gift_for_friend").observeEventType(.Value, withBlock: { (snapshot) in
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    self.gifts = []
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
                        self.gifts.append(gift)
                        self.tableView.reloadData()
                    })
                }
            })
    }



    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ProgressTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GiftTableViewCell
        cell.giftNameLabel?.text = self.gifts[indexPath.row].name
        cell.giftDueDateLabel?.text = self.gifts[indexPath.row].dueDate
        cell.giftReasonCell?.text = "For " + self.gifts[indexPath.row].reason!
        let url = NSURL(string: self.gifts[indexPath.row].pictureURL! as NSString as String)
        let data = NSData(contentsOfURL: url!)
        cell.giftImageView.contentMode = .ScaleAspectFit
        cell.giftImageView.image = UIImage(data: data!)
        cell.giftProgressView.transform = CGAffineTransformMakeScale( 1, 3)
        cell.giftProgressView.setProgress(Float(self.gifts[indexPath.row].progress!/self.gifts[indexPath.row].price!), animated: false)
        
        let f = Float(self.gifts[indexPath.row].progress!/self.gifts[indexPath.row].price!) * 100
        let progress = String(format: "%.01f", f)
        cell.progressViewNumber.text = progress + "%"
        
        
        // Fetches the appropriate meal for the data source layout.
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gifts.count
    }
    
}

