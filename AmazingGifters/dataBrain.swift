//
//  dataBrain.swift
//  AmazingGifters
//
//  Created by 陆恺 on 7/3/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import Firebase

class dataBrain{
    var searchText:String?
    static let sharedDataBrain = dataBrain()
    var user:User!
    var ref : FIRDatabaseReference!
    var uid:String!
    var visitedUser:User!
    
    
    private init(){
        self.ref = FIRDatabase.database().reference()
    }
    
    func login(uid:String,profile:NSDictionary!){
        self.uid = uid
        self.user  = User(id: self.uid)
        self.user.profile = profile
        self.user.createNewOrUpdate(self.ref)
    }
    
    func addNewGift(newGift: Gift){   //add gift to Firebase
        let giftRef = ref.child("gift") // Firebase database reference
        let newGiftDic = ["item_id": newGift.itemID! as String,
                          "item_url":newGift.itemURL! as String,
                          "due_date": newGift.dueDate! as String,
                          "initiator_id": newGift.initiatorID! as String,
                          "name": newGift.name! as String,
                          "picture_url": newGift.pictureURL! as String,
                          "post_time": newGift.postTime! as String,
                          "price":newGift.price! as Double,
                          "reason":newGift.reason! as String,
                          "receiver_id":newGift.receiverID! as String,
                          "progress": 0.0,
                          "category" : newGift.category! as String]
        let giftChild = giftRef.childByAutoId() // Add a new key-value pair to the "gift" map
        let autoId = giftChild.key
        giftChild.setValue(newGiftDic) // Write gift profile to the database
        newGift.auto_id = autoId
        //Add gift-id to "user" map
        if self.user.uid == visitedUser.uid{
            ref.child("user").child(self.user.uid).child("my_gift").child("wish_list").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let giftListItem = [autoId: true]
                self.ref.child("user").child(self.user.uid).child("my_gift").child("wish_list").updateChildValues(giftListItem)
            })
        }else{
            ref.child("user").child(visitedUser.uid).child("my_gift").child("from_friends").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let giftListItem = [autoId: true]
                self.ref.child("user").child(self.visitedUser.uid).child("my_gift").child("from_friends").updateChildValues(giftListItem)
            })
            ref.child("user").child(self.user.uid).child("gift_for_friend").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let giftListItem = [autoId: true]
                self.ref.child("user").child(self.user.uid).child("gift_for_friend").updateChildValues(giftListItem)
            })
        }
    }

 
    func setContacts(contactsList:[User]) {
        for friend in contactsList{
            friend.getProfile(self.ref)
            self.user.contactsList.append(friend)
        }
    }

 
}