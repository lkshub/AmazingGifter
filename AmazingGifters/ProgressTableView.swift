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

class ProgressTableView: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    

    let brain = dataBrain.sharedDataBrain
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var gifts:[Gift]=[]{
        didSet{
            tableView.reloadData()
        }
    }
    var allGifts:[Gift]=[]
    var user:User!
    private var searchText:String?{
        didSet{
            //contacts.removeAll()
            searchForGifts()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = brain.user
        fetchGifts()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    private func searchForGifts(){
        var filtered = [Gift]()
        if let text = searchText where !text.isEmpty{
            for gift in self.allGifts{
                if let name = gift.name{
                    if name.rangeOfString(text) != nil{
                        filtered.append(gift)
                    }else{
                        if let receiverName = gift.receiverName{
                            if receiverName.rangeOfString(text) != nil{
                                filtered.append(gift)
                            }
                        }
                    }
                }
            }
            self.gifts = filtered
        }else{
            self.gifts = self.allGifts
        }
    }
    
    func fetchGifts(){
            brain.ref.child("user").child(self.user.uid).child("gift_for_friend").observeEventType(.Value, withBlock: { (snapshot) in
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    self.gifts = []
                    self.allGifts = []
                    let element = rest.key
                    self.brain.ref.child("gift").child(element).observeEventType(.Value, withBlock: { (snapshot) in
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
                            progress: (snapshot.value!["progress"] as? Double)!
                        )
                        self.brain.ref.child("user").child(gift.receiverID!).child("name").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                            let name = snapshot.value as? String
                            gift.receiverName = name
                            self.gifts.append(gift)
                            self.allGifts.append(gift)
                            })
                        //self.tableView.reloadData()
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
        cell.giftReasonCell?.text = "For "+self.gifts[indexPath.row].receiverName!+"'s "+self.gifts[indexPath.row].reason!
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.gifts = self.allGifts
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

