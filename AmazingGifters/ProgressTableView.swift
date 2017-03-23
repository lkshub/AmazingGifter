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
    fileprivate var searchText:String?{
        didSet{
            //contacts.removeAll()
            searchForGifts()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showProgressDetailTableSegue"
        {
            if let destinationVC = segue.destination as? GiftDetailTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    destinationVC.gift = gifts[indexPath.row]
                    cell.isSelected = false
                    
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = brain.user
        fetchGifts()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    fileprivate func searchForGifts(){
        var filtered = [Gift]()
        if let text = searchText, !text.isEmpty{
            for gift in self.allGifts{
                if let name = gift.name{
                    if name.range(of: text) != nil{
                        filtered.append(gift)
                    }else{
                        if let receiverName = gift.receiverName{
                            if receiverName.range(of: text) != nil{
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
    
    func fetchGiftsOnce(){
            brain.ref.child("user").child(self.user.uid).child("gift_for_friend").observeSingleEvent(of: .value, with: { (snapshot) in
                let enumerator = snapshot.children
                
                while let rest = enumerator.nextObject() as? FIRDataSnapshot {
                    self.gifts = []
                    self.allGifts = []
                    let element = rest.key
                    self.brain.ref.child("gift").child(element).observeSingleEvent(of: .value, with: { (snapshot) in
                        if !(snapshot.value is NSNull) {
                            let gift = self.getGiftFromSnapshot(element,snapshot:snapshot)
                            self.brain.ref.child("user").child(gift.receiverID!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                                let name = snapshot.value as? String
                                gift.receiverName = name
                                self.gifts.insert(gift, at: 0)
                                self.allGifts.insert(gift, at: 0)
                            })
                        }
                    })
                }
            })
    }
    func fetchGifts(){
        brain.ref.child("user").child(self.user.uid).child("gift_for_friend").observe(.childAdded, with: { (snapshot) in
            
            let element = snapshot.key
            self.brain.ref.child("gift").child(element).observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                if !(snapshot.value is NSNull) {
                    let gift = self.getGiftFromSnapshot(element,snapshot:snapshot)
                    self.brain.ref.child("user").child(gift.receiverID!).child("name").observeSingleEvent(of: .value, with: { (snapshot) in
                        let name = snapshot.value as? String
                        gift.receiverName = name
                        self.gifts.insert(gift, at: 0)
                        self.allGifts.insert(gift, at: 0)
                    })
                }
            })
            self.brain.ref.child("gift").child(element).observe(.childChanged, with: { (snapshot) in
                self.fetchGiftsOnce()
            })
            
        })
        brain.ref.child("user").child(self.user.uid).child("gift_for_friend").observe(.childRemoved, with: { (snapshot) in
            self.fetchGiftsOnce()
        })
    }

    func getGiftFromSnapshot(_ auto_id:String, snapshot:FIRDataSnapshot) -> Gift{
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
            hidden: false
        )
        gift.auto_id = auto_id
        return gift
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ProgressTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GiftTableViewCell
        cell.giftNameLabel?.text = self.gifts[indexPath.row].name
        cell.giftDueDateLabel?.text = self.gifts[indexPath.row].dueDate
        cell.giftReasonCell?.text = "For "+self.gifts[indexPath.row].receiverName!+"'s "+self.gifts[indexPath.row].reason!
        let url = URL(string: self.gifts[indexPath.row].pictureURL! as NSString as String)
        let data = try? Data(contentsOf: url!)
        cell.giftImageView.contentMode = .scaleAspectFit
        cell.giftImageView.image = UIImage(data: data!)
        cell.giftProgressView.transform = CGAffineTransform( scaleX: 1, y: 3)
        cell.giftProgressView.setProgress(Float(self.gifts[indexPath.row].progress!/self.gifts[indexPath.row].price!), animated: false)
        
        let f = Float(self.gifts[indexPath.row].progress!/self.gifts[indexPath.row].price!) * 100
        let progress = String(format: "%.01f", f)
        cell.progressViewNumber.text = progress + "%"
        
        
        // Fetches the appropriate meal for the data source layout.
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gifts.count
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchText = ""
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
    }
}

