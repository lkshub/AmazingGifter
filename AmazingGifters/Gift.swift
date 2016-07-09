//
//  Gift.swift
//  AmazingGifters
//
//  Created by Chong Wu Guo on 7/4/16.
//  Copyright © 2016 Kai Lu. All rights reserved.
//

import Foundation
import Firebase

class Gift{
    /*
    private var giftID:String
    init(id:String){
        self.giftID = id
    }
    
    init(newID,dueDate,name,url,pictureUrl,postTime,price,reason,initiatorID,receiverID:String){
        giftID = newID
        let post = [
        
    }
     */
    var itemID : String?
    var itemURL : String?
    var dueDate: String?
    var initiatorID: String?
    var name: String?
    var pictureURL: String?
    var postTime: String?
    var price: Double?
    var reason: String?
    var receiverID: String?
    var progress: Double?
    var receiverName : String?
    
    init(dic: NSDictionary){
       
            self.itemID = dic["itemID"] as? String
            self.itemURL = dic["itemURL"] as? String
            self.dueDate = dic["dueDate"] as? String
            self.initiatorID = dic["initiatorID"] as? String
            self.name = dic["name"] as? String
            self.pictureURL = dic["pictureURL"] as? String
            self.postTime = dic["postTime"] as? String
            self.price = dic["price"] as? Double
            self.reason = dic["reason"] as? String
            self.receiverID = dic["receiverID"] as? String
            self.progress = dic["progress"] as? Double
    
    }
    init(itemID: String,itemURL: String, dueDate: String,initiatorID :String, name:String, pictureURL:String, postTime:String, price:String, reason:String, receiverID :String) {
        self.itemID = itemID
        self.itemURL = itemURL
        self.dueDate = dueDate
        self.initiatorID = initiatorID
        self.name = name
        self.pictureURL = pictureURL
        self.postTime = postTime
        self.price = Double(price.substringToIndex((price.rangeOfString(" ")?.startIndex)!))
        self.reason = reason
        self.receiverID = receiverID
        self.progress = 0.0
    }
    init(itemID: String,itemURL: String, dueDate: String,initiatorID :String, name:String, pictureURL:String, postTime:String, price:Double, reason:String, receiverID :String, progress: Double) {
        self.itemID = itemID
        self.itemURL = itemURL
        self.dueDate = dueDate
        self.initiatorID = initiatorID
        self.name = name
        self.pictureURL = pictureURL
        self.postTime = postTime
        self.price = price
        self.reason = reason
        self.receiverID = receiverID
        self.progress = progress
    }
    /*
    func createNewGift(ref:FIRDatabaseReference) {
        let giftRef = ref.child("gift")
        let newGift = ["itemID": self.itemID! as String,
                       "itemURL":self.itemURL! as String,
                       "dueDate": self.dueDate! as String,
                       "initiatorID": self.initiatorID! as String,
                       "name": self.name! as String,
                       "pictureURL": self.pictureURL! as String,
                       "postTime": self.postTime! as String,
                       "price":self.price! as Double,
                       "reason":self.reason! as String,
                       "receiverID":self.receiverID! as String,
                       "progress": 0.0]
        let gift1Ref = giftRef.childByAutoId()
        gift1Ref.setValue(newGift)

    }
 */

  
}